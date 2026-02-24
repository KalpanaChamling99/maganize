# db/seeds.rb — idempotent seed data for magazine app

# ── Roles ─────────────────────────────────────────────────────────────────────
root_role = Role.find_or_create_by!(name: "Root Admin") do |r|
  r.permissions = Role::ALL_PERMISSIONS
end

Role.find_or_create_by!(name: "Admin") do |r|
  r.permissions = Role::ALL_PERMISSIONS - ["manage_roles"]
end

Role.find_or_create_by!(name: "Editor") do |r|
  r.permissions = %w[
    view_articles create_articles edit_articles delete_articles
    manage_categories manage_tags manage_collections delete_media
  ]
end

Role.find_or_create_by!(name: "Viewer") do |r|
  r.permissions = %w[view_articles]
end

puts "Roles: #{Role.count} (#{Role.pluck(:name).join(', ')})"

# ── Admin User ───────────────────────────────────────────────────────────────
root = AdminUser.find_or_initialize_by(email: "admin@magazine.com")
root.name     = "Admin"
root.role     = root_role
root.password = "password123" if root.new_record?
root.save!
puts "AdminUser ready  →  admin@magazine.com / password123  (Root Admin)"

# ── Categories ──────────────────────────────────────────────────────────────
category_names = [
  "Culture",
  "Technology",
  "Politics",
  "Science",
  "Travel",
  "Food & Drink",
  "Fashion",
  "Health & Wellness",
  "Business",
  "Environment",
  "Arts",
  "Sports",
  "Literature",
  "Film & TV",
  "Music",
  "Photography",
  "Architecture",
  "History",
  "Education",
  "Opinion"
]

categories = category_names.map do |name|
  Category.where("LOWER(name) = ?", name.downcase).first || Category.create!(name: name)
end

puts "Categories: #{categories.count}"

# ── Tags ─────────────────────────────────────────────────────────────────────
tag_names = [
  "longform",
  "interview",
  "analysis",
  "review",
  "photography",
  "investigation",
  "essay",
  "feature",
  "profile",
  "data",
  "opinion",
  "explainer",
  "dispatch",
  "reportage",
  "portrait",
  "archive",
  "first-person",
  "criticism",
  "documentary",
  "visual"
]

tags = tag_names.map do |name|
  Tag.where("LOWER(name) = ?", name.downcase).first || Tag.create!(name: name)
end

puts "Tags: #{tags.count}"

# ── Articles ─────────────────────────────────────────────────────────────────
articles_data = [
  {
    title: "The Quiet Revolution Reshaping Our Cities",
    excerpt: "How urban planners are rethinking the streets we inherited from the automobile age.",
    body: "Across the world, a slow but decisive transformation is under way. Streets once dominated by cars are being handed back to pedestrians, cyclists, and the commons of public life. In Barcelona, the superblock experiment has reduced traffic in entire neighbourhoods by 60 percent. In Oslo, a city of half a million has virtually eliminated pedestrian fatalities at motor-vehicle crossings.\n\nThe idea is neither new nor radical in its origins. Jane Jacobs argued in 1961 that vibrant streets depend on density, mixed use, and eyes on the ground. What is new is the political will — and, crucially, the measurement tools — to act on that insight at scale.\n\n\"We used to optimise streets for the movement of vehicles,\" says urban mobility researcher Ananya Krishnan. \"Now we're beginning to optimise them for the movement of people — which turns out to be a very different problem.\"\n\nThe shift is not without resistance. Business owners near Oslo's pedestrianised Strøget initially forecast financial ruin; retail turnover rose by a third within two years. The pattern has repeated in city after city, yet the argument must be relitigated each time.",
    category_index: 0,
    tag_indexes: [0, 7, 11],
    featured: true,
    published_at: 14.days.ago
  },
  {
    title: "Inside the Lab Trying to Extend Human Lifespan by 50 Years",
    excerpt: "A visit to Calico, Alphabet's secretive research company dedicated to understanding why we age.",
    body: "The campus sits behind a stand of eucalyptus in South San Francisco, its low glass buildings giving nothing away. Inside, some of the world's best biologists are chasing a problem that has defeated every civilisation before them: why organisms age, and whether anything can be done about it.\n\nCalico — formally the California Life Company — was founded in 2013 with backing from Alphabet and an unusual mandate. Not to treat the diseases of ageing, but to understand ageing itself as a biological phenomenon. The distinction matters. Treating Alzheimer's or cancer extends healthy life at the margin; cracking the molecular clockwork of senescence could, in theory, move the margin entirely.\n\nThe science is moving faster than the public debate. Partial cellular reprogramming, senolytics, and precision interventions in mTOR signalling have extended healthy lifespan in model organisms by factors that would have seemed fantastical a decade ago. Whether any of it translates to humans remains the unanswered question.\n\n\"We're not promising immortality,\" says one researcher, who asked not to be named. \"We're promising rigour.\"",
    category_index: 1,
    tag_indexes: [0, 2, 7],
    featured: true,
    published_at: 10.days.ago
  },
  {
    title: "The Chefs Who Are Quietly Changing What We Eat",
    excerpt: "A new generation of cooks is building a cuisine rooted in fermentation, foraging, and radical restraint.",
    body: "It begins, as so much in contemporary cooking does, with a bucket of salt and time. René Leroux tips a kilo of green tomatoes into brine and seals the lid. In three weeks, they will taste of something entirely different from what they are now — deeper, stranger, better.\n\nLeroux runs a twelve-seat restaurant in Lyon that has no written menu and no walk-in refrigerator. Everything on the plate was either grown in the kitchen garden, foraged within twenty kilometres, or fermented in-house. He is not alone. Across Europe and North America, a cohort of cooks is reaching similar conclusions independently: that the most interesting flavours are already present in raw ingredients, waiting to be coaxed out by patience rather than technique.\n\nThe philosophy has roots in Nordic cuisine's early-2000s awakening, but it has evolved into something less doctrinaire. Where Noma once felt like a manifesto, these new restaurants feel like quiet arguments — premises demonstrated rather than stated.\n\n\"Fermentation teaches you to get out of the way,\" says Amara Osei, whose Bristol restaurant has a two-year waiting list. \"The microbes do the work. Your job is to create conditions for them.\"",
    category_index: 5,
    tag_indexes: [0, 3, 7],
    featured: false,
    published_at: 7.days.ago
  },
  {
    title: "What the Internet Did to Memory",
    excerpt: "We outsourced our recall to machines. Now neuroscientists are asking what we lost in the bargain.",
    body: "For most of human history, memory was the architecture of culture. The oral traditions of the Homeric world, the memory palaces of Renaissance scholars, the dense mnemonic systems of Indigenous knowledge-keepers — all depended on the same biological substrate: a brain trained, through repetition and effort, to hold and retrieve information.\n\nThe smartphone changed that contract in ways we are only beginning to understand. A growing body of research suggests that the habit of cognitive offloading — reaching for a device rather than exercising recall — is reshaping how memory works, and possibly what we use it for.\n\n\"Transactive memory has always existed,\" says cognitive scientist Dr. Maria Fernandez. \"We've always divided memory labour with people around us — you remember birthdays, I remember directions. What's new is the scale and the passivity. We're offloading to a system that doesn't push back, doesn't require us to encode anything.\"\n\nThe consequences range from the trivial (most people can no longer recite their partner's phone number) to the potentially significant (studies show that recalling information from memory, rather than looking it up, substantially deepens understanding of it).",
    category_index: 1,
    tag_indexes: [2, 8, 11],
    featured: false,
    published_at: 5.days.ago
  },
  {
    title: "A Season in Oaxaca",
    excerpt: "The Mexican state that became a culinary pilgrimage site is grappling with what tourism has wrought.",
    body: "The mezcal arrives before noon, poured into a small clay cup by a woman who has been making it on this hillside for forty years. Her name is Doña Carmen, and she is explaining, through a translator, why the denomination of origin laws that were meant to protect producers like her have instead made it harder for small distillers to compete with industrial operations that export hundreds of thousands of litres a year.\n\nThis is the paradox at the heart of modern Oaxaca. The state's cuisine — its moles, tlayudas, chapulines, and the deep, smoky complexity of artisanal mezcal — has made it one of the world's most celebrated food destinations. That celebrity has brought money, infrastructure, and global attention. It has also brought displacement, appropriation, and a hospitality economy in which the people most celebrated are often the least compensated.\n\nThe tension is not unique to Oaxaca. It plays out wherever culinary tourism intersects with communities that have been historically marginalised. What distinguishes Oaxaca is the clarity with which locals articulate the stakes.",
    category_index: 4,
    tag_indexes: [0, 13, 16],
    featured: true,
    published_at: 3.days.ago
  },
  {
    title: "The Return of the Printed Page",
    excerpt: "Independent magazines are thriving. Here is why ink on paper refuses to die.",
    body: "The newsstand at the corner of Coldharbour Lane in Brixton carries 340 different titles. A decade ago it carried fewer than 100. The owner, Marcus Webb, has been selling magazines for thirty-one years, and he says the current moment is unlike anything he has seen before.\n\n\"The big weeklies are gone or going,\" he says, gesturing toward a gap on the shelf. \"But the independents — the ones that cost fifteen pounds and take three months to read — those are selling better than ever.\"\n\nThe numbers bear him out. Pew Research data shows that while general-interest magazine circulation has declined steadily since 2008, the independent and specialist sector has grown by more than 40 percent over the same period. Titles like Delayed Gratification, Hole & Corner, and The Gentlewoman command loyal readerships and charge prices that would have seemed impossible twenty years ago.\n\nThe explanation, most publishers agree, is the inverse of what the optimists predicted about digital media. Abundance, it turns out, creates appetite for scarcity. When everything is available instantly, the object that rewards patience acquires new value.",
    category_index: 12,
    tag_indexes: [2, 7, 17],
    featured: false,
    published_at: 2.days.ago
  },
  {
    title: "Portrait of the Artist as an Algorithm",
    excerpt: "Generative AI can now produce images indistinguishable from photographs. What does that mean for photography?",
    body: "The photograph of the Afghan girl was taken in 1984 by Steve McCurry and appeared on the cover of National Geographic in June 1985. It has been called the world's most recognised photograph. In 2023, an AI system trained on millions of images produced, in response to the prompt \"Afghan refugee girl, green eyes, National Geographic cover, film photography,\" something that is, to most observers, indistinguishable from it.\n\nThis is not, photography theorists are quick to point out, a new problem. Photoshop made image manipulation trivially easy thirty years ago. What is new is the generative capacity — the ability to produce not a manipulated photograph but a synthetic image that never had a real-world referent at all.\n\nThe implications extend beyond the professional concerns of working photographers, though those concerns are real and urgent. At a deeper level, the question is about the evidential status of the photographic image. For most of its history, a photograph carried an implicit claim: that the light hitting the sensor or the film had been reflected from something that existed. That claim is now structurally broken.",
    category_index: 15,
    tag_indexes: [6, 2, 18],
    featured: true,
    published_at: 1.day.ago
  },
  {
    title: "How Sleep Became the New Status Symbol",
    excerpt: "The wealthy are spending fortunes on rest. The science of sleep explains why they might be right.",
    body: "The sleep concierge arrives at the hotel suite at nine in the evening, carrying a case that contains, among other things, a portable white-noise machine, blackout liners for the curtains, a selection of pillow densities, and a small device that chills the mattress to the precise temperature that sleep researchers have identified as optimal for deep-wave sleep onset.\n\nThe service costs £850 per night, and it is fully booked three months ahead.\n\nWe are living through a sleep revolution — or at least a sleep obsession. After decades in which the willingness to function on minimal rest was treated as a professional virtue (\"I'll sleep when I'm dead,\" Margaret Thatcher reportedly said), the cultural valence has reversed. Sleep is now a competitive advantage, a wellness marker, a form of self-optimisation that the serious professional ignores at their peril.\n\nThe science underpinning this shift is more solid than most wellness trends. Matthew Walker's 2017 book Why We Sleep brought rigorous sleep research to a popular audience and made a case, based on decades of evidence, that chronic sleep deprivation is a public health crisis on a par with obesity or sedentary behaviour.",
    category_index: 7,
    tag_indexes: [11, 7, 9],
    featured: false,
    published_at: 6.hours.ago
  },
  {
    title: "The Philosopher Who Predicted the Attention Economy",
    excerpt: "Herbert Simon wrote about information overload in 1971. We are still living in his footnotes.",
    body: "In 1971, the economist and cognitive scientist Herbert Simon wrote a short essay that deserves to be far more famous than it is. Published in a collection on computers and communications, it contains the following observation: \"A wealth of information creates a poverty of attention and a need to allocate that attention efficiently among the overabundance of information sources that might consume it.\"\n\nSimon was writing about the then-nascent challenge of information management in organisations. He could not have known that he was describing, with almost uncanny precision, the defining condition of life fifty years later. He certainly could not have known that the mechanism for exploiting that poverty of attention — the algorithmic attention economy — would become one of the most powerful economic forces in human history.\n\nThe attention economy did not require a conspiracy to emerge. It required, instead, a particular configuration of incentives, technologies, and human psychology that makes the exploitation of attention not merely profitable but structurally inevitable once the tools exist to do it at scale.",
    category_index: 3,
    tag_indexes: [6, 2, 10],
    featured: false,
    published_at: 4.days.ago
  },
  {
    title: "Living Off the Land in Rural Japan",
    excerpt: "A growing movement of urban escapees is reviving depopulated villages through agriculture and craft.",
    body: "The village of Nishi-Awa in Tokushima Prefecture once had a population of several thousand. When Kenji Nakamura arrived eight years ago, there were ninety-three residents, the youngest of whom was forty-seven. Today there are one hundred and twenty-eight, and the youngest is six months old.\n\nNakamura is part of a broader movement that has, quietly and without much fanfare, begun to reverse Japan's rural depopulation in selected pockets of the country. The inaka gurashi — rural life — movement attracts urban professionals who trade Tokyo salaries for something harder to quantify: the ability to grow their own food, make things with their hands, and live in a community small enough that their neighbours know their names.\n\nThe movement has been accelerated by the pandemic, which demonstrated that knowledge-economy jobs can be done from anywhere, and by a generalised disillusionment with urban life among younger Japanese — a generation that entered the workforce during the Lost Decades and has watched property prices in Tokyo spiral beyond reach.\n\n\"I earn less,\" says Nakamura, who now grows rice and makes ceramics. \"I own more. I'm not sure those two things are unrelated.\"",
    category_index: 4,
    tag_indexes: [13, 16, 1],
    featured: false,
    published_at: 8.days.ago
  },
  {
    title: "The Architecture of Grief",
    excerpt: "How the spaces we build for mourning shape the way we experience loss.",
    body: "The Vietnam Veterans Memorial in Washington DC was, when Maya Lin's design was selected in 1981, one of the most controversial architectural decisions in American history. Veterans' groups objected to its abstraction; politicians called it a \"black gash of shame.\" Forty years later, it is routinely described as the most visited monument in Washington and one of the most powerful works of public art in the world.\n\nWhat changed was not the memorial — Lin's design was built exactly as she proposed it. What changed was the understanding of what grief requires in public space: not triumphalism, not narrative, but a surface that reflects the visitor back to themselves while holding the weight of the names.\n\nMemorial architecture has undergone a quiet revolution since Vietnam. The shift is away from the heroic and toward the contemplative; away from bronze generals on horseback and toward negative space, reflection pools, and the raw material of names. Peter Eisenman's Holocaust Memorial in Berlin, Snøhetta's National September 11 Memorial Museum in New York, and the Apartheid Museum in Johannesburg all share this grammar, despite their radical differences in context and scale.",
    category_index: 16,
    tag_indexes: [6, 17, 2],
    featured: false,
    published_at: 12.days.ago
  },
  {
    title: "The Scientists Listening to the Ocean Floor",
    excerpt: "Hydrophone networks are revealing a world of sound beneath the sea that we are only beginning to understand.",
    body: "The sound arrives through headphones as a low, rhythmic pulse — not quite music, not quite machinery. It is, explains marine bioacoustician Dr. Sofia Reyes, the call of a fin whale recorded 800 metres below the surface of the North Atlantic, transmitted through a hydrophone network that spans the ocean basin.\n\nThe network — NOAA's Integrated Ocean Observing System — was originally built to monitor submarine activity during the Cold War. Its declassification in the 1990s gave marine scientists access to an extraordinary archive: decades of continuous acoustic recording from one of the planet's most remote environments.\n\nWhat they have found has overturned assumptions. The ocean is not quiet. Below the threshold of surface noise — shipping lanes, sonar pings, the low rumble of propellers — there is a constant acoustic ecology, a soundscape shaped by biology, geology, and the physics of deep water.\n\n\"We thought we were monitoring a dead environment,\" says Dr. Reyes. \"We were listening to a city.\"",
    category_index: 3,
    tag_indexes: [0, 9, 7],
    featured: false,
    published_at: 9.days.ago
  },
  {
    title: "The Other Streaming Wars",
    excerpt: "While Hollywood fights for subscribers, a quieter battle is being waged over music, podcasts, and audiobooks.",
    body: "When Spotify went public in 2018, its pitch to investors rested on a single, audacious claim: that it would do to audio what Netflix had done to video. At the time, this seemed like hubris dressed as strategy. Audio, analysts pointed out, was not video. The economics were different, the content economics were different, the user behaviour was different.\n\nSix years later, the hubris looks rather more like foresight. Spotify now has 600 million monthly active users — more than Netflix — and has expanded from music into podcasting, audiobooks, and, most recently, live events. Its rivals in music streaming — Apple Music, Amazon Music, YouTube Music, Tidal — have each attracted hundreds of millions of users. The audio economy dwarfs the video economy by most measures except cultural attention.\n\nThe reason is structural. Audio is ambient. You can listen while doing almost anything else. It fits into the margins of a day that video cannot occupy. And the marginal cost of audio content — while not trivial — is substantially lower than film or television, enabling a broader and more experimental content ecosystem.",
    category_index: 13,
    tag_indexes: [2, 11, 9],
    featured: false,
    published_at: 11.days.ago
  },
  {
    title: "A Brief History of the Waiting Room",
    excerpt: "What the spaces that make us wait reveal about power, time, and the organisation of modern life.",
    body: "The waiting room is a relatively recent invention. Before the nineteenth century, the experience of waiting for professional services — medical, legal, governmental — was managed through different social technologies: the anteroom, the queue, the appointment book, the letter of introduction. The waiting room as a distinct architectural type, with its particular furniture, its out-of-date magazines, its careful arrangement of chairs that avoid eye contact without quite enforcing isolation, is a product of the industrial age.\n\nIt emerged, argues design historian Penelope Harris, from the confluence of two things: the professionalisation of middle-class services and the democratisation of access to those services. When a doctor or lawyer served only the gentry, the waiting problem did not arise — you were seen when the professional was ready, and you waited in whatever social space was appropriate to your station. When those professionals began serving a broader public on a scheduled basis, they needed somewhere to put the people who arrived early or had to wait for the person ahead of them.\n\nThe room that resulted has been remarkably stable in its essential grammar for 150 years, despite radical changes in the services it precedes.",
    category_index: 18,
    tag_indexes: [17, 6, 14],
    featured: false,
    published_at: 15.days.ago
  },
  {
    title: "Inside the World of Professional Foragers",
    excerpt: "A subculture of expert wild-food collectors is navigating the line between tradition, legality, and ecological stewardship.",
    body: "Miles Irving has been foraging professionally for twenty years. He supplies mushrooms, sea vegetables, and wild herbs to some of Britain's most decorated restaurants, and he has written the definitive English-language handbook on the subject. He is also, at various points in his career, been prosecuted for trespass, accused of stripping woodland bare, and celebrated as a custodian of traditional ecological knowledge.\n\nAll three characterisations contain some truth, he says, which is part of what makes professional foraging so difficult to regulate and so easy to misunderstand.\n\nThe practice sits at a peculiar intersection of contemporary food culture — wild, seasonal, traceable ingredients command premium prices in the restaurant world — and something much older: the accumulated knowledge of what is edible, where it grows, and when to take it that was once common property and is now the specialist knowledge of a small professional cohort.\n\n\"The word foraging has been colonised by lifestyle,\" says Irving. \"The reality is harder and stranger than the Instagram version. And the ecology is actually quite demanding if you want to do it without doing damage.\"",
    category_index: 5,
    tag_indexes: [14, 0, 7],
    featured: false,
    published_at: 6.days.ago
  },
  {
    title: "The Comeback of Vinyl — and What It Hides",
    excerpt: "Record sales have grown for seventeen consecutive years. But the economics of physical music remain precarious.",
    body: "The vinyl revival is, by now, a story that has been told many times, usually in a tone of pleased surprise. Record sales in the US exceeded CD sales for the first time in 2020 — the first time that had happened since 1986. In the UK, vinyl now accounts for more revenue than all digital downloads combined. Independent record stores, which were being written off at the turn of the millennium, have grown in number every year since 2007.\n\nBut the numbers require some unpacking. The revival has been concentrated, geographically and demographically, in ways that the aggregate figures obscure. It is largely an urban phenomenon, a middle-class phenomenon, and a phenomenon driven by a relatively small number of high-spending enthusiasts who buy far more records than average.\n\nMore importantly, the economics of vinyl production have not kept up with demand. Pressing plants — many of which closed in the 1990s when the format seemed terminally dead — are now running at full capacity, with lead times of up to a year for new releases. The shortage has driven up prices and pushed smaller labels and artists to the back of the queue.\n\n\"Vinyl is thriving culturally and struggling economically,\" says Hannah Park, who runs an independent label in Manchester. \"Those two things are not as contradictory as they sound.\"",
    category_index: 14,
    tag_indexes: [2, 3, 9],
    featured: false,
    published_at: 13.days.ago
  },
  {
    title: "What Modern Football Owes to Johan Cruyff",
    excerpt: "Fifty years after Total Football, the Dutchman's ideas have never been more influential — or more misunderstood.",
    body: "In 1974, the Netherlands national football team arrived at the World Cup in West Germany playing a style of football that had no name. The coaches who faced them in the draw — East Germany, Argentina, Uruguay, Brazil — watched footage and concluded that they were looking at something they did not have a tactical vocabulary to describe.\n\nJohan Cruyff did not invent Total Football. That credit belongs to his coach at Ajax, Rinus Michels, and to the theorists of the Hungarian national team of the 1950s who were Michels's intellectual forebears. What Cruyff did was embody it, articulate it, and — most importantly — transmit it. Every major coaching influence of the past thirty years leads back, through one or two degrees of separation, to Cruyff.\n\nPep Guardiola played under Cruyff at Barcelona. Guardiola's former assistants now manage half the clubs in Europe. The positional play that Guardiola developed, and that has become the dominant tactical paradigm of the modern game, is a direct descendant of Total Football — modified, refined, and made more rigorous by advances in data analysis, but recognisably the same idea.\n\n\"Football,\" Cruyff said, \"is a game you play with your brain.\"",
    category_index: 11,
    tag_indexes: [17, 14, 2],
    featured: false,
    published_at: 16.days.ago
  },
  {
    title: "The Designers Reimagining Political Posters",
    excerpt: "A new wave of graphic designers is borrowing from the history of agitprop to make arguments for the present.",
    body: "The poster is the oldest mass medium. Before newspapers, before radio, before the internet, the poster was how governments, movements, and merchants communicated with publics that were largely illiterate and entirely without screens. Its grammar — bold type, high contrast, simple image, arresting colour — was developed under constraints that no longer exist and has survived the removal of those constraints entirely.\n\nPolitical poster design has had several golden ages. The Russian Constructivists of the 1920s; the Bauhaus; the New Deal muralists; the civil rights movement's mastery of photographic montage; the punk-era appropriation of ransom-note aesthetics. Each of these moments combined aesthetic innovation with political urgency in ways that produced work that outlasted both.\n\nA new wave of designers — working largely outside institutional frameworks, distributing through social media, and drawing explicitly on the traditions they cite — is making a case that the poster has something to offer the present political moment that digital media cannot.\n\n\"The poster is committed,\" says designer Chioma Eze. \"It takes a position and holds it. It does not have a comments section.\"",
    category_index: 10,
    tag_indexes: [7, 6, 19],
    featured: false,
    published_at: 18.days.ago
  },
  {
    title: "The Secret Life of Academic Publishing",
    excerpt: "How a handful of corporations came to control the world's scientific knowledge — and what researchers are doing about it.",
    body: "The business model of academic publishing is, on its face, extraordinary. Researchers — employed by universities and funded largely by public grants — produce work that they submit, free of charge, to journals. Other researchers — also publicly funded — then peer-review that work, also free of charge. The journals then sell the resulting publications back to university libraries at prices that have risen at three times the rate of inflation for thirty years.\n\nThe five largest academic publishers — Elsevier, Springer Nature, Wiley, Taylor & Francis, and SAGE — collectively generate profit margins between 30 and 40 percent. By comparison, Apple's net profit margin is approximately 25 percent. The comparison is not exact, but it gives a sense of the scale.\n\nThe model persists because it is entangled with the incentive structures of academic careers. Publication in high-impact journals — which are overwhelmingly controlled by the major publishers — is the primary criterion for hiring, promotion, and grant allocation. Researchers who boycott the system risk their careers; institutions that cancel subscriptions risk losing access to work their researchers need.\n\n\"It's a hostage situation,\" says one senior academic, who asked to remain anonymous. \"The hostage is scientific knowledge, and everyone is paying the ransom.\"",
    category_index: 18,
    tag_indexes: [6, 9, 2],
    featured: false,
    published_at: 20.days.ago
  },
  {
    title: "Notes on a Disappearing Landscape",
    excerpt: "As the Arctic changes faster than anywhere else on Earth, a photographer documents what is being lost.",
    body: "I have been coming to Svalbard for eleven years. The first time, I photographed a glacier that extended to within 400 metres of the fjord's edge. Last summer, I stood in the same position and the ice was 2.3 kilometres away. The land it had left behind — raw, grey, streaked with mineral deposits — had the look of something that had not seen light in a very long time, which is precisely what it was.\n\nPhotographing climate change presents a particular representational challenge. The subject is vast, slow, and largely invisible to the eye that encounters it over a human timescale. The glacier retreats by centimetres each day; you cannot see that. The permafrost thaws; you cannot see that either. What you can photograph are the consequences — the collapsed buildings, the dried lakebeds, the bleached coral — but by the time you can see the consequences, you are documenting damage rather than danger.\n\nI have developed, over these years, a different approach. I photograph the same locations, at the same time of year, from the same positions. The differences between my images from 2013 and my images from this year are not subtle. They are the differences between a living landscape and one that is being unmade.\n\nI do not know what photography is for in this context. I know what it is against.",
    category_index: 9,
    tag_indexes: [15, 4, 16],
    featured: true,
    published_at: Time.current
  }
]

created = 0
articles_data.each do |data|
  next if Article.exists?(title: data[:title])

  article = Article.create!(
    title:        data[:title],
    excerpt:      data[:excerpt],
    body:         data[:body],
    category:     categories[data[:category_index]],
    featured:     data[:featured],
    published_at: data[:published_at]
  )

  article.tags = data[:tag_indexes].map { |i| tags[i] }
  created += 1
end

puts "Articles created: #{created} (#{Article.count} total)"
