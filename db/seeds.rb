# db/seeds.rb — idempotent seed data for magazine app

# ── Roles ─────────────────────────────────────────────────────────────────────
# Always sync permissions so adding new permission keys is picked up on re-seed.
root_role = Role.find_or_initialize_by(name: "Root Admin")
root_role.permissions = Role::ALL_PERMISSIONS
root_role.save!

admin_role = Role.find_or_initialize_by(name: "Admin")
admin_role.permissions = Role::ALL_PERMISSIONS - ["manage_roles"]
admin_role.save!

editor_role = Role.find_or_initialize_by(name: "Editor")
editor_role.permissions = %w[
  view_articles create_articles edit_articles delete_articles
  manage_categories manage_tags manage_collections delete_media
]
editor_role.save!

viewer_role = Role.find_or_initialize_by(name: "Viewer")
viewer_role.permissions = %w[view_articles]
viewer_role.save!

puts "Roles: #{Role.count} (#{Role.pluck(:name).join(', ')})"

# ── Default Super Admin ───────────────────────────────────────────────────────
# Ensures there is always at least one Root Admin account.
# Password is only set on first creation — existing accounts are not overwritten.
root = AdminUser.find_or_initialize_by(email: "admin@magazine.com")
root.name = "Admin" if root.new_record?
root.role = root_role
if root.new_record?
  root.password = "password123"
  root.save!
  puts "SuperAdmin created  →  admin@magazine.com / password123  (change this password!)"
else
  root.save!
  puts "SuperAdmin present  →  admin@magazine.com  (Root Admin)"
end

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
    featured:     data[:featured],
    published_at: data[:published_at]
  )

  article.categories = [categories[data[:category_index]]]
  article.tags = data[:tag_indexes].map { |i| tags[i] }
  created += 1
end

puts "Articles created: #{created} (#{Article.count} total)"

# ── Additional Articles ───────────────────────────────────────────────────────
additional_articles_data = [
  {
    title: "The Language of Bees",
    excerpt: "Karl von Frisch spent decades decoding how honeybees communicate direction and distance — a discovery that changed biology.",
    body: "In a garden in Munich in the 1940s, Karl von Frisch watched a honeybee return to its hive, and then watched what happened next. The bee danced. Not randomly — the dance had structure, rhythm, angle relative to gravity. And the other bees watched, and then left the hive and flew, with extraordinary precision, to the food source the returning bee had found.\n\nVon Frisch had, in that garden, discovered one of the most remarkable communication systems in the animal kingdom. The waggle dance encodes direction as angle relative to vertical, and encodes distance as duration of the waggle phase. It is, in effect, a symbolic language — abstract, referential, and learned — in a creature whose brain is the size of a grass seed.\n\nThe discovery won Von Frisch the Nobel Prize in 1973. More importantly, it permanently disrupted the assumption that complex symbolic communication was exclusively human.",
    category_index: 3,
    tag_indexes: [0, 2, 7],
    featured: false,
    published_at: 22.days.ago
  },
  {
    title: "Why Restaurants Fail — and Why We Keep Opening Them",
    excerpt: "The economics of the restaurant industry are catastrophic. Chefs open them anyway.",
    body: "The statistics are well known and routinely ignored. Roughly 60 percent of restaurants fail in their first year. Eighty percent are gone within five years. Profit margins, in a good year, hover between three and nine percent — lower than almost any other retail category. The labour is brutal, the hours are inhuman, and the customers are frequently unkind.\n\nAnd yet people keep opening restaurants. In 2023, more new restaurants opened in the United States than in any year since records began.\n\nThe explanation, argues food economist Lars Petersen, is not economic but psychological. \"Restaurants are the only business where your customers are emotionally invested in your success,\" he says. \"The joy people take in a great meal, in their neighbourhood place, creates a kind of loyalty that no other retail sector can produce. Chefs experience that loyalty and mistake it for sustainable economics.\"\n\nThere is also something about the restaurant as a stage — the performance of hospitality, the immediacy of feedback, the social life of the kitchen — that attracts people for whom conventional business would be unbearable.",
    category_index: 5,
    tag_indexes: [2, 9, 7],
    featured: false,
    published_at: 23.days.ago
  },
  {
    title: "The Town That Invented the Weekend",
    excerpt: "How a mill town in New England became the unlikely birthplace of the two-day break.",
    body: "The five-day work week is so embedded in modern life that it is almost impossible to imagine its absence. But the concept is recent — and its origin is more specific than most people know.\n\nIn 1908, a cotton mill in Manchester, New Hampshire, became the first factory in the United States to adopt a two-day weekend. The owner, Ernest Bader, did not do it for altruistic reasons. He did it to accommodate his Jewish employees, who observed Saturday as the Sabbath. By giving everyone Saturday off, he avoided having to run two different shift schedules.\n\nThe experiment proved more productive than the six-day schedule it replaced. Workers came back Monday refreshed. Absenteeism fell. Henry Ford noticed. In 1926, Ford Motor Company became the first major manufacturer to adopt the five-day week for all employees — and where Ford went, American industry followed.\n\nThe weekend, then, is an accident of religious accommodation and industrial pragmatism, not a recognition of any natural rhythm of human life. The implication — that the rhythm we treat as natural is in fact contingent — has become increasingly relevant as remote work destabilises the week's structure once more.",
    category_index: 17,
    tag_indexes: [17, 11, 2],
    featured: false,
    published_at: 24.days.ago
  },
  {
    title: "The Quiet Art of Bookbinding",
    excerpt: "In an era of digital reading, a handful of craftspeople are keeping an ancient skill alive — and finding new audiences for it.",
    body: "The workshop smells of leather and paste. On a long wooden bench, Maria Santos is pressing the spine of a Coptic-bound journal, her thumbs moving with the practiced certainty of someone who has made this gesture ten thousand times. She has been bookbinding for thirty-two years, and she says the demand for hand-bound books has never been higher.\n\n\"People want things that last,\" she says. \"They want to hold something that required a human being to make it. The phone is everywhere. The handmade book is nowhere. That's why it has value.\"\n\nThe Coptic stitch — a technique developed in Egyptian monasteries in the first centuries of the common era — exposes the spine and allows the book to lie flat when open. It is functional as well as beautiful, which may explain why it has survived, in virtually unchanged form, for nearly two thousand years.\n\nSantos runs workshops that are booked six months ahead. Her students are primarily professionals in their thirties and forties — people who spend their working hours in front of screens and want, at the end of that working day, to make something physical with their hands.",
    category_index: 10,
    tag_indexes: [7, 6, 4],
    featured: false,
    published_at: 25.days.ago
  },
  {
    title: "The New Geography of Remote Work",
    excerpt: "Five years after the pandemic transformed where people work, the map of human settlement is being redrawn.",
    body: "In 2019, the population of Bozeman, Montana, was 50,000. By 2024, it was 75,000. The median home price rose from $380,000 to $680,000. Traffic on the main arterial roads doubled. The outdoor equipment stores became coffee shops became co-working spaces became outdoor equipment stores again, each iteration serving a slightly different demographic.\n\nBozeman is an extreme example of a phenomenon that has reshaped dozens of mid-sized cities across North America and Europe: the migration of knowledge workers to places that combine natural amenity with fiber-optic internet and an airport with connections to major hubs.\n\nThe consequences are multiple and not uniformly positive. For longtime residents, property prices have risen beyond reach. For regional economies, the influx of high-earning remote workers has created jobs in hospitality and construction while driving out the service workers those jobs require. For the cities losing knowledge workers — primarily large, expensive, high-density metros — the effects on tax revenue and culture are still being measured.\n\nWhat is clear is that the pandemic-era experiment with remote work proved something the office partisans had long denied: that knowledge work, in many of its forms, can be done from anywhere with a screen and a connection.",
    category_index: 8,
    tag_indexes: [2, 9, 11],
    featured: false,
    published_at: 26.days.ago
  },
  {
    title: "Portrait: The Last Typewriter Repairman",
    excerpt: "Tom Furrier has been fixing typewriters in Cambridge, Massachusetts, for forty years. He is not planning to stop.",
    body: "The shop is on Massachusetts Avenue, between a Vietnamese restaurant and a laundromat, and it has been there since 1982. The window display has not changed meaningfully in that time: a row of typewriters in various states of assembly, a handwritten sign advertising repairs and ribbons, and a Remington Quiet De Luxe from 1956 that Tom Furrier keeps there because it is beautiful and because nobody has ever offered to buy it at a price he considers sensible.\n\nFurrier is sixty-three. He learned to repair typewriters from his father, who learned from a correspondence course. He can fix anything with a carriage and a ribbon, including machines that manufacturers discontinued before he was born.\n\nThe customers, he says, have changed in ways that have surprised him. Twenty years ago, they were mostly elderly people who had always typed on typewriters and resisted the computer. Now they are young — students, writers, musicians who want a physical writing instrument that doesn't connect to the internet.\n\n\"They want to write without distraction,\" he says. \"And you can't distract a typewriter. It doesn't have notifications. It just types.\"",
    category_index: 10,
    tag_indexes: [8, 14, 7],
    featured: false,
    published_at: 27.days.ago
  },
  {
    title: "Inside the World's Largest Seed Bank",
    excerpt: "The Svalbard Global Seed Vault holds over a million varieties of crops. It may be the most important building ever constructed.",
    body: "The vault is buried 130 metres into the permafrost of a mountain in the Norwegian archipelago of Svalbard, 1,300 kilometres from the North Pole. Its entrance — a concrete wedge emerging from the snow, lit by an art installation that glows in the polar darkness — looks like something from a science-fiction film. It is, in fact, something more remarkable: an insurance policy for the global food supply.\n\nThe Svalbard Global Seed Vault currently holds 1.3 million seed samples, representing more than 6,000 plant species. Its purpose is to preserve the genetic diversity of the world's crops against the possibility — increasingly less hypothetical — of catastrophic loss through climate change, disease, conflict, or institutional failure.\n\nThe vault has already been used. In 2015, the Syrian conflict destroyed the Aleppo gene bank, one of the most important collections of dryland crop varieties in the world. Researchers withdrew samples from Svalbard, propagated them in Morocco and Lebanon, and returned the replenished collection. The vault worked exactly as designed.\n\n\"We built something that we hope we never need,\" says Crop Trust director Stefan Schmitz. \"We were wrong about that. We needed it almost immediately.\"",
    category_index: 3,
    tag_indexes: [7, 9, 11],
    featured: false,
    published_at: 28.days.ago
  },
  {
    title: "How Fonts Shape What We Think",
    excerpt: "Typography is not neutral. The typeface you read a message in can change how you feel about the message.",
    body: "In 2012, New York Times columnist Errol Morris ran an experiment. He presented readers with a passage of text about the pessimistic views of philosopher David Hume, and asked whether they agreed with the passage. Unknown to readers, he presented the same text in two different typefaces: Baskerville and Comic Sans.\n\nReaders who saw the Baskerville version were significantly more likely to agree with the passage than those who saw the Comic Sans version. The content was identical. The typeface did the work.\n\nThis result surprises people who haven't thought about typography, and doesn't surprise anyone who has. Typefaces carry centuries of cultural association. Serif fonts — Times, Garamond, Baskerville — are associated with authority, tradition, and seriousness. Sans-serif fonts — Helvetica, Futura, Gill Sans — carry associations of modernity, efficiency, and neutrality. Comic Sans carries associations of casualness, amateurism, and — for reasons that have never been fully explained — intense disapproval.\n\n\"Typography is the voice in which text speaks,\" says type designer Erik Spiekermann. \"You can say the same words in a whisper, a shout, or an ironic drawl. The typeface is the voice.\"",
    category_index: 10,
    tag_indexes: [2, 6, 11],
    featured: false,
    published_at: 29.days.ago
  },
  {
    title: "The Science of Awe",
    excerpt: "Psychologists have spent two decades studying what happens when we encounter something that stops us in our tracks.",
    body: "The first time Jonathan Haidt encountered awe as a scientific subject, he was struck by how little psychology had said about it. Fear, joy, sadness, disgust — these had been studied exhaustively. But awe — the emotion of encountering something vast, sublime, and beyond the scope of existing understanding — had been largely neglected.\n\nHaidt, working with psychologist Dacher Keltner, proposed the first scientific definition of awe in 2003. Their paper described two conditions for awe: perceived vastness (the stimulus is large or complex in some way that dwarfs ordinary experience) and a need for accommodation (the experience doesn't fit existing frameworks and requires updating them).\n\nThe subsequent research has been striking. Awe reliably produces a specific cluster of effects: a slowing of subjective time, a reduction in self-focused thinking, an increase in prosocial behaviour, and a sense of being part of something larger than oneself. People who experience awe score higher on measures of wellbeing, are more willing to volunteer their time, and are less likely to cheat in economic games.\n\n\"Awe makes you feel small,\" says Keltner. \"And feeling small — the right kind of small — turns out to be very good for you.\"",
    category_index: 3,
    tag_indexes: [2, 6, 11],
    featured: false,
    published_at: 30.days.ago
  },
  {
    title: "Rethinking the School Day",
    excerpt: "The evidence that teenagers should start school later is overwhelming. Why won't anyone act on it?",
    body: "The biology is clear. Adolescent sleep patterns shift during puberty, driven by changes in circadian rhythm, making it physiologically difficult for teenagers to fall asleep before 11 pm or wake before 8 am. School systems that start at 7:30 or 8 am are requiring adolescents to function at the biological equivalent of 4 am.\n\nThe consequences are well documented: chronic sleep deprivation in teenagers is associated with lower academic performance, higher rates of depression and anxiety, more automobile accidents (teenagers are significantly overrepresented in early-morning crash statistics), and higher rates of obesity. The economic cost of adolescent sleep deprivation has been calculated, by RAND researchers, at $9 billion per year in the United States alone.\n\nThe research has been building for thirty years. The American Academy of Pediatrics recommended later start times in 2014. More than forty peer-reviewed studies have reached the same conclusion. In 2019, California passed a law mandating that middle and high schools start no earlier than 8:30 am — the first state in the US to do so.\n\n\"This is one of those rare situations in public health where the intervention is free, the evidence is overwhelming, and almost nobody acts on it,\" says sleep researcher Matthew Walker. \"The explanation is logistics, not science.\"",
    category_index: 18,
    tag_indexes: [11, 2, 9],
    featured: false,
    published_at: 31.days.ago
  },
  {
    title: "The Painter Who Worked in Darkness",
    excerpt: "Vija Celmins spent thirty years making images of the night sky. A new retrospective asks what she was looking for.",
    body: "The paintings are small — rarely larger than a notebook page — and they are painted in a range of grey, from almost-white to almost-black. They depict the night sky, the surface of the ocean, and the surface of the desert. They depict these subjects with a precision so complete that they read, at a distance, as photographs.\n\nUp close, the brushwork reveals itself: thousands of tiny, deliberate marks, each placed with absolute control, building up a surface that takes months or years to complete. Vija Celmins does not use photographs as source material. She works from memory, from physical experience of the subjects, and from a commitment to representing not what the camera sees but what the mind holds.\n\nThe new retrospective at the Met gathers forty years of work and makes it possible to trace the development of a singular obsession. Why the sky? Why the ocean? Why the desert? Celmins has answered these questions in interviews and declined to answer them in interviews, sometimes in the same conversation.\n\n\"I'm not interested in symbolism,\" she has said. \"I'm interested in surface. The sky is a surface. So is the ocean. So is the canvas. I'm interested in the relationship between them.\"",
    category_index: 10,
    tag_indexes: [6, 14, 19],
    featured: false,
    published_at: 32.days.ago
  },
  {
    title: "What Chess Teaches About Decision-Making",
    excerpt: "Grandmasters don't think further ahead than amateur players. They think differently. The distinction matters.",
    body: "The popular image of chess genius is computational: the master player who can see twenty moves ahead, calculating permutations that the amateur cannot conceive of. This image is wrong. In 1946, Dutch psychologist Adriaan de Groot asked chess grandmasters and club players to think aloud as they examined positions. The grandmasters didn't look further ahead. They looked at fewer positions — but the positions they looked at were the right ones.\n\nWhat distinguished expert from amateur was not calculation but pattern recognition. Grandmasters have internalised roughly 50,000 patterns — configurations of pieces — from years of study and play. When they look at a position, they see these patterns immediately, which tells them where the interesting moves are. They don't calculate every option; they calculate the options that matter.\n\nThis finding has implications far beyond chess. It suggests that expertise, in general, is less about computational power than about the quality of pattern libraries — the accumulated templates that allow experts to quickly identify what is relevant and ignore what is not.\n\n\"The expert's advantage is not thinking more,\" says cognitive psychologist Gary Klein. \"It's thinking about different things.\"",
    category_index: 3,
    tag_indexes: [2, 9, 11],
    featured: false,
    published_at: 33.days.ago
  },
  {
    title: "The Economics of Free Time",
    excerpt: "As automation threatens jobs, economists are revisiting a question Keynes asked in 1930: what will we do with abundance?",
    body: "In 1930, John Maynard Keynes published a short essay called \"Economic Possibilities for Our Grandchildren.\" He predicted that by 2030, technological progress would have so increased productive capacity that the central economic problem — scarcity — would be largely solved. His grandchildren's generation, he suggested, would face a new and more pleasant problem: what to do with fifteen-hour work weeks and vast amounts of leisure time.\n\nKeynes was wrong about the timeline. He was also wrong about who would benefit from the productivity gains — they went, with remarkable consistency, to capital rather than labour. But the underlying question has become newly urgent as automation threatens to displace not just manual labour but cognitive labour as well.\n\nThe debate about Universal Basic Income, which has moved from the fringes of economics to its mainstream in two decades, is partly a debate about what Keynes's future would look like in practice. Would guaranteed income liberate people to pursue meaningful unpaid work — caregiving, art, civic engagement? Or would it produce purposeless idleness?\n\nThe evidence from pilot programs, which now include data from Kenya, Finland, Stockton (California), and dozens of other sites, suggests the answer is closer to the former.",
    category_index: 8,
    tag_indexes: [2, 9, 6],
    featured: false,
    published_at: 34.days.ago
  },
  {
    title: "The Making of a Marathon Runner",
    excerpt: "What it takes to run 26.2 miles, and why the training is not what most people imagine.",
    body: "At 4:45 in the morning, Jomo Mwangi is already running. He has been running since he was seven years old in the Rift Valley region of Kenya, first to school and back, then in earnest. He is now twenty-six and has a marathon personal best of 2:05:47, which puts him in the top thirty marathon runners who have ever lived.\n\nThe training for elite marathon running is not what most people imagine. The volume is extraordinary — 160 to 200 kilometres per week, more than four times the weekly mileage most recreational runners aspire to — but most of it is run at a pace that feels, to Mwangi, almost embarrassingly slow. The hard sessions are infrequent and carefully calibrated. The emphasis is on recovery as much as effort.\n\n\"People think training is about suffering,\" says his coach, David Rudisha. \"Elite training is about adaptation. You apply a stimulus. You recover completely. You apply a slightly larger stimulus. The adaptation happens in the recovery, not the stimulus. Runners who train hard all the time never recover. They never adapt.\"\n\nThis principle — that rest is not the absence of training but its completion — extends well beyond running, into music, mathematics, and creative work.",
    category_index: 11,
    tag_indexes: [8, 7, 1],
    featured: false,
    published_at: 35.days.ago
  },
  {
    title: "The Newspapers That Would Not Die",
    excerpt: "Independent local journalism was supposed to have been finished off by the internet. Some outlets had other plans.",
    body: "In 2009, the Seattle Post-Intelligencer, one of the oldest newspapers in the American West, shut down its print edition and laid off 145 of its 165 staff. Most industry observers assumed this was the beginning of the end for the newspaper. It wasn't. The online-only SeattlePI continued publishing, hired a small staff, and today reaches more monthly readers than the print edition ever did.\n\nAcross the country, a different kind of resurrection has been happening. Local news organisations that appeared terminally wounded have been rebuilt as nonprofits, cooperatives, or public-benefit corporations — legal structures that remove the pressure for quarterly earnings and allow editorial decisions to be made on journalistic rather than financial grounds.\n\nThe Texas Tribune, the Connecticut Mirror, the Salt Lake Tribune — all have made this transition successfully. The Philadelphia Inquirer is now owned by a nonprofit. The Baltimore Banner launched as a nonprofit in 2022 and has grown faster than almost any new news organisation in American history.\n\n\"The local news crisis was a business model crisis,\" says journalism researcher Emily Roseman. \"When you change the business model, you change the trajectory.\"",
    category_index: 12,
    tag_indexes: [2, 9, 7],
    featured: false,
    published_at: 36.days.ago
  },
  {
    title: "Ocean Farming and the Future of Protein",
    excerpt: "Seaweed, shellfish, and fish farms are being reimagined as a solution to the protein problem. Can it scale?",
    body: "The farm is three nautical miles off the coast of Connecticut, and it is entirely underwater. Kelp grows in vertical columns from the surface to twenty feet down. Oysters hang in mesh sacks below the kelp. Mussels cluster on ropes. The whole operation requires no fresh water, no fertiliser, no pesticide, and no land.\n\nGregor Shumway, who runs GreenWave, the organisation that developed this polyculture system, describes it as \"3D ocean farming\" — using the vertical dimension of the water column to grow multiple crops simultaneously, each one creating conditions that benefit the others.\n\nThe environmental argument for ocean farming is strong. Shellfish filter water and sequester carbon. Kelp grows faster than any land plant and absorbs CO2 as it does so. The system requires no inputs beyond sunlight and seawater. The product — shellfish and seaweed — is nutritionally dense and requires less processing than land-grown protein.\n\nThe challenge is cultural as much as agricultural. Americans eat very little seaweed and relatively little shellfish. Changing dietary habits is a slower and less predictable project than designing a new farming system.\n\n\"We can grow the food,\" says Shumway. \"The question is whether we can grow the appetite.\"",
    category_index: 9,
    tag_indexes: [7, 11, 9],
    featured: false,
    published_at: 37.days.ago
  },
  {
    title: "The City That Banned Cars — and Thrived",
    excerpt: "Pontevedra, Spain, removed cars from its centre in 1999. Two decades later, the data tells a remarkable story.",
    body: "In 1999, the mayor of Pontevedra, a small city in Galicia in northwest Spain, made a decision that his critics called economically ruinous. He banned private cars from the city centre. Not reduced, not traffic-calmed — banned.\n\nMiguel Lores expected business owners to leave and residents to revolt. Neither happened. Businesses reported increased footfall almost immediately. Residents, freed from the noise and danger of car traffic, began using outdoor spaces that had been inaccessible for decades. Children played in streets that had been, within living memory, major traffic arteries.\n\nTwenty-five years later, the data is unambiguous. Air pollution is down by 67 percent. Road deaths have been zero for more than a decade. Tax revenue from the centre has increased by 12 percent. Retail occupancy is at 97 percent.\n\n\"We didn't ban cars to punish drivers,\" says Lores. \"We banned cars to give the city back to people. It turned out that people — not cars — are what makes a city economically alive.\"\n\nThe Pontevedra model has been studied by urban planners from Paris to Seoul, and has influenced a generation of car-free city centre experiments across Europe. The results, while not uniform, have been consistently more positive than predicted.",
    category_index: 0,
    tag_indexes: [2, 11, 7],
    featured: false,
    published_at: 38.days.ago
  },
  {
    title: "The Sound of Silence",
    excerpt: "Acoustic ecologist Gordon Hempton has spent forty years searching for places where natural quiet still exists. There are very few.",
    body: "Gordon Hempton defines natural silence not as the absence of sound — there is no such thing in nature — but as the absence of human-generated sound for more than fifteen minutes at a time. By this definition, there are fewer than twelve such places remaining in the contiguous United States.\n\nHempton has been recording these places since 1980, building an archive of natural soundscapes that has become, as the sounds themselves become rarer, an inadvertent document of loss. He has recorded dawn choruses, river systems, desert winds, and ice fields. He has also recorded, in the same locations over decades, the gradual intrusion of aircraft noise, road traffic, and industrial sound.\n\nThe effect of noise pollution on wildlife is now well established. Bird species that rely on song for mating and territorial defence are abandoning habitats that have become too noisy. Marine mammals that navigate by echolocation are being disoriented by shipping noise. Bats that hunt by hearing are losing prey to acoustic interference.\n\nThe effect on human beings is less dramatic but no less real. Research consistently shows that chronic exposure to noise increases cortisol levels, disrupts sleep, and is associated with higher rates of cardiovascular disease. The quiet that Hempton seeks is not a luxury — it is, the evidence suggests, a biological necessity.",
    category_index: 9,
    tag_indexes: [15, 4, 9],
    featured: false,
    published_at: 39.days.ago
  },
  {
    title: "How the Library Reinvented Itself",
    excerpt: "The public library was supposed to become obsolete in the age of the internet. Instead, it became more essential.",
    body: "In 2004, the Pew Research Center published a report asking whether public libraries were still relevant in the age of Google. The report's conclusion — tentatively, hedged — was that they probably were, though the case needed to be made more clearly.\n\nIn 2024, Pew published a follow-up. The libraries had not merely survived: they had expanded their services, grown their footfall, and taken on functions that no other public institution was equipped to provide. The modern library offers not just books but legal clinics, tax preparation assistance, mental health resources, job coaching, digital skills training, seed libraries, tool libraries, and community meeting space.\n\nThe transformation required reimagining the library's core purpose. The original purpose — providing access to information — had been at least partly superseded by the internet. The new purpose — providing access to expertise, community, and the social infrastructure of civic life — turned out to be at least as important, and entirely complementary to digital technology.\n\n\"Libraries became the internet's supplement, not its victim,\" says librarian and urban studies scholar Eric Klinenberg. \"The internet gave everyone access to information. The library gives everyone access to guidance about what to do with it.\"",
    category_index: 18,
    tag_indexes: [7, 11, 2],
    featured: false,
    published_at: 40.days.ago
  },
  {
    title: "The Anthropology of the Commute",
    excerpt: "Hundreds of millions of people spend hours each day in transit. What that time does to us — and for us.",
    body: "The average American commuter spends 27 minutes each way on their daily journey to work. The average London commuter spends 47 minutes. These are averages; the distribution has a long tail. There are people in the greater Tokyo area who commute for three hours each way, five days a week, for careers that span three decades.\n\nCommuting has been consistently ranked, in time-use studies, as one of the least enjoyable activities in the modern day. It ranks below working, below household chores, even below receiving medical care. And yet most people with commutes retain them voluntarily — choosing jobs that require transit over jobs that do not.\n\nThe explanation is not masochism. It is the commute's function as a transitional space — a zone between home and work that serves, for many people, as a decompression chamber. Research shows that people who eliminate their commutes through remote work often recreate some version of it: a deliberate walk before logging on, a drive that goes nowhere in particular, a physical ritual of transition.\n\n\"The commute isn't just transport,\" says sociologist Anthony Elliott. \"It's liminality. It's the crossing of a threshold. And most people find, when they remove the threshold, that they miss it.\"",
    category_index: 0,
    tag_indexes: [2, 17, 9],
    featured: false,
    published_at: 41.days.ago
  },
  {
    title: "Notes from the Antarctic Ice",
    excerpt: "A season at a research station at the bottom of the world, watching scientists do their work in the most remote laboratory on Earth.",
    body: "The flight from Christchurch takes five hours, over water and then over ice — an ocean of ice, flat and white and without feature, extending to every horizon. When the LC-130 lands at McMurdo Station, the temperature outside is minus twenty-three Celsius, and the wind is doing the rest.\n\nMcMurdo, the largest Antarctic research station, houses about a thousand people in summer and about two hundred in winter. It has a fire station, a greenhouse, a convenience store, and a bar called Gallagher's that is open every day, including Christmas. It looks like a mining town and functions like a small city.\n\nThe research conducted here ranges from glaciology to astrophysics to marine biology. Some of the most important climate data in the world comes from ice cores extracted here — cylinders of ancient ice that contain, in their air bubbles, samples of the atmosphere from hundreds of thousands of years ago.\n\nWhat strikes a visitor is not the extremity of the environment — though the extremity is real and constant — but the normalcy of the work. Scientists here wake up, eat breakfast, go to the lab, and do science. The cold is ambient. The isolation becomes, in time, simply the condition under which work happens.",
    category_index: 3,
    tag_indexes: [13, 9, 15],
    featured: false,
    published_at: 42.days.ago
  },
  {
    title: "The Fashion Industry's Climate Problem",
    excerpt: "Clothing is the second most polluting industry on Earth. The solution is not more sustainable fashion — it is less fashion.",
    body: "The statistics are familiar and have not produced sufficient change. The fashion industry is responsible for 10 percent of global carbon emissions — more than aviation and shipping combined. It consumes 93 billion cubic metres of water per year. It produces 92 million tonnes of textile waste annually. The average garment is worn seven times before being discarded.\n\nThe industry's response has been sustainability campaigns: organic cotton, recycled polyester, capsule collections, and the language of circular fashion. The campaigns are not false, exactly, but they are insufficient. Sustainability improvements at the production level are routinely outpaced by increases in production volume. H&M and Zara produce more garments each year than the year before. The \"sustainable\" garments are additional to the unsustainable ones, not replacements for them.\n\nThe systemic analysis is straightforward but commercially unpopular: the fashion industry's environmental impact cannot be meaningfully reduced without reducing the volume of fashion produced and consumed. This requires either regulation — mandatory caps on production, extended producer responsibility for waste — or a cultural shift in the relationship between consumers and clothing.\n\n\"The sustainable fashion movement is largely a marketing category,\" says fashion journalist Tansy Hoskins. \"The real argument — buy less, wear it longer — is very hard to monetise.\"",
    category_index: 6,
    tag_indexes: [2, 9, 11],
    featured: false,
    published_at: 43.days.ago
  },
  {
    title: "The Philosophy of Ruins",
    excerpt: "Why do we find beauty in decay? What collapsed buildings and abandoned cities tell us about time and meaning.",
    body: "There is a German word — Ruinenlust — for the pleasure of contemplating ruins. It entered the cultural vocabulary in the eighteenth century, when Romantic painters discovered that crumbling Roman aqueducts and vine-covered medieval fortresses produced a particular emotional response: a mixture of melancholy, awe, and something like comfort.\n\nThe comfort, argues art historian Christopher Woodward in his study of ruins, comes from perspective. A ruin is a monument to the passage of time — not as abstraction but as physical evidence. Standing before Hadrian's Wall or the Colosseum or the temples of Angkor, the human mind performs a calculation that is otherwise difficult: it grasps, viscerally, that civilisations rise and fall, that what seems permanent is not, and that this truth is neither comforting nor terrifying but simply the condition of things.\n\nThe digital age has complicated the philosophy of ruins. Physical decay requires time, and time requires absence of maintenance. But digital systems can decay catastrophically and instantaneously — and leave no ruins, only silence. The websites of the early internet are simply gone, unarchived, leaving no trace. The philosophy of ruins requires an object that time can act on. The digital may be the first medium that time cannot reach.",
    category_index: 17,
    tag_indexes: [6, 2, 17],
    featured: false,
    published_at: 44.days.ago
  },
  {
    title: "The Women Who Built the Space Race",
    excerpt: "Before the astronauts, there were the computers. The Black mathematicians at NASA whose work made the missions possible.",
    body: "In the early 1960s, NASA's Langley Research Center in Hampton, Virginia, employed several hundred people with the job title \"computer.\" The word referred not to a machine but to a person — someone who performed mathematical calculations by hand or with mechanical calculators. Many of these computers were women. A significant number were Black women, working in a segregated facility in the American South.\n\nThe story of these women — Dorothy Vaughan, Mary Jackson, Katherine Johnson, and their colleagues — was told, belatedly, in Margot Lee Shetterly's 2016 book Hidden Figures and the film adaptation that followed. John Glenn, before his historic orbital flight in 1962, insisted that Katherine Johnson check by hand the trajectory calculations that had been produced by the new electronic computers. He trusted her arithmetic over the machines.\n\nThe broader history of women's contributions to computing — from Ada Lovelace to the ENIAC programmers — has followed a pattern that historians have now documented extensively: women doing foundational technical work, men receiving the recognition, and the women's contributions becoming visible only decades later as their names are recovered from archives.\n\nThe pattern is not unique to computing, but computing offers unusually clear evidence of it.",
    category_index: 17,
    tag_indexes: [0, 8, 2],
    featured: false,
    published_at: 45.days.ago
  },
  {
    title: "A Year of Eating Seasonally",
    excerpt: "One food writer's attempt to eat only what was grown locally and in season. What she learned about taste, habit, and convenience.",
    body: "The experiment began in January, which is the worst time to begin an experiment in seasonal eating in Britain. The list of what was growing locally was short: kale, celeriac, leeks, parsnips, stored apples, stored potatoes. Eggs from a neighbour's chickens. A little hard cheese.\n\nBy February, I had eaten kale in more ways than I had previously known kale could be prepared. Kale raw in salad. Kale wilted with garlic. Kale in soup. Kale braised with lentils. Kale with eggs. By March, the arrival of the first purple sprouting broccoli felt like a genuinely joyful event, which I had not previously thought possible of a vegetable.\n\nThe experiment changed my eating in ways I had not anticipated. The obvious lesson — that seasonal, local produce tastes better — I already knew, or thought I did. What I hadn't understood was how deeply convenience had shaped my food habits, and how much of what I had taken to be preference was actually convenience dressed as preference.\n\nThere were failures. The experiment coincided with a period of extreme cold, during which the local root vegetables froze in the ground. I ate more tinned goods than intended. I also broke the rules twice: once for a friend's birthday dinner, and once for a specific craving for Thai food that overwhelmed my scruples completely.",
    category_index: 5,
    tag_indexes: [16, 9, 7],
    featured: false,
    published_at: 46.days.ago
  },
  {
    title: "The Myth of the Self-Made Billionaire",
    excerpt: "Every great fortune stands on public infrastructure, collective knowledge, and historical accident. Why do we keep pretending otherwise?",
    body: "In 2011, Elizabeth Warren gave a speech at a campaign event in Andover, Massachusetts, that went viral. \"There is nobody in this country who got rich on their own,\" she said. \"You built a factory out there — good for you. But I want to be clear. You moved your goods to market on the roads the rest of us paid for. You hired workers the rest of us paid to educate.\"\n\nThe speech attracted roughly equal amounts of approval and fury. The fury came largely from people who felt that Warren was mischaracterising how wealth creation works — that she was diminishing individual initiative, creativity, and risk-taking.\n\nBut the underlying argument has substantial empirical support. Mariana Mazzucato's research shows that the technologies underlying every major Silicon Valley success story — the internet, GPS, touchscreens, SIRI — were developed through public funding, primarily by DARPA and the National Science Foundation. The companies commercialised these technologies, often brilliantly. They did not invent them.\n\nThis is not an argument against private enterprise. It is an argument about the conditions that make private enterprise possible — and about who should bear the cost of maintaining those conditions.",
    category_index: 8,
    tag_indexes: [6, 2, 10],
    featured: false,
    published_at: 47.days.ago
  },
  {
    title: "The Man Who Catalogued Every Plant on Earth",
    excerpt: "Carl Linnaeus created the system of biological classification in 1753. Two hundred and seventy years later, scientists are still using it — and arguing about it.",
    body: "In 1753, Carl Linnaeus published Species Plantarum, in which he named and classified approximately 5,900 species of plants. The work established the binomial nomenclature system — genus and species, always in Latin, always italicised — that biologists still use today. When a new species of orchid is discovered in the cloud forests of Ecuador, it receives a Linnaean name, assigned according to rules established in the eighteenth century.\n\nThe system's longevity is remarkable given how much our understanding of life has changed since Linnaeus devised it. DNA sequencing has repeatedly overturned classifications that seemed stable for centuries, revealing that organisms that look similar are not closely related, and organisms that look very different share recent common ancestors.\n\nThe result is a taxonomy in constant flux. The number of species on Earth is estimated at between eight and one trillion — no one knows — and the rate of new discoveries far exceeds the rate of formal description. There is a backlog of perhaps twenty million undescribed species, most of them insects and fungi.\n\n\"We're in the middle of the greatest extinction event since the Cretaceous,\" says taxonomist Quentin Wheeler. \"And we don't even know what we're losing.\"",
    category_index: 3,
    tag_indexes: [17, 9, 7],
    featured: false,
    published_at: 48.days.ago
  },
  {
    title: "The Radical Simplicity of Slow Travel",
    excerpt: "What happens when you decide to go somewhere and take the longest route available.",
    body: "The journey from London to Istanbul by rail takes approximately forty-five hours if you do it efficiently: the Eurostar to Paris, TGV to Munich, overnight train to Bucharest, another overnight to Istanbul. Done in consecutive days, with some planning, it is a perfectly manageable trip that most people could accomplish with a decent rail pass and a tolerance for booking windows.\n\nI took three weeks. I stopped in Brussels, Cologne, Vienna, Budapest, Belgrade, Sofia, and half a dozen smaller places between. I missed connections deliberately. I ate in station restaurants that have no TripAdvisor listings. I met a retired schoolteacher in the dining car who had been making the same journey annually for thirty years and could describe, in precise detail, how every station buffet had changed since the 1990s.\n\nSlow travel has become, in the last decade, something of a movement — partly for environmental reasons (rail produces a fraction of the carbon of aviation) and partly for reasons that are harder to articulate. The journey becomes the destination. The in-between places are not interruptions to the trip but the trip itself.\n\n\"Speed is a kind of violence done to experience,\" says travel writer Pico Iyer. \"Slow travel is the antidote.\"",
    category_index: 4,
    tag_indexes: [16, 0, 13],
    featured: false,
    published_at: 49.days.ago
  },
  {
    title: "The Genetics of Musical Talent",
    excerpt: "Is musical ability inherited? What the science says — and what it doesn't say — about nature, nurture, and the ear.",
    body: "In the early 1990s, psychologist K. Anders Ericsson published research suggesting that musical expertise was primarily a product of practice — specifically, the approximately 10,000 hours of deliberate practice that separated elite performers from competent amateurs. The research was widely popularised, most influentially by Malcolm Gladwell in Outliers, and entered public consciousness as the \"10,000-hour rule.\"\n\nSubsequent research has complicated the picture significantly. Twin studies consistently show that musical ability has a heritability of between 40 and 70 percent — meaning that genetic factors account for a substantial portion of the variation between individuals. Studies of perfect pitch — the ability to identify a musical note without a reference tone — show even higher heritability, and have identified specific genetic variants associated with the trait.\n\nThe nuanced conclusion, which is also the least satisfying for anyone seeking a simple answer, is that both nature and nurture matter substantially, that they interact in complex ways, and that the relative contribution of each varies by specific ability. Perfect pitch appears to be highly heritable. Rhythmic ability appears to be somewhat heritable. Motivation to practise — which turns out to be one of the strongest predictors of musical achievement — appears to be moderately heritable.\n\n\"We're not nature versus nurture,\" says musician-scientist Daniel Levitin. \"We're nature via nurture.\"",
    category_index: 14,
    tag_indexes: [2, 3, 9],
    featured: false,
    published_at: 50.days.ago
  },
  {
    title: "What the Amazon Knows",
    excerpt: "Indigenous forest-dwellers have accumulated ecological knowledge over millennia. Western science is only beginning to understand its depth.",
    body: "The Kayapó people of the Brazilian Amazon have no word for \"weed.\" This is not a linguistic curiosity — it reflects an understanding of plant ecology that differs fundamentally from the agricultural worldview in which some plants are wanted and others are not.\n\nKayapó land management practices, studied since the 1980s by ethnobotanist Darrell Posey, involve the deliberate cultivation of patches of seemingly wild vegetation at forest edges — patches that turn out, on examination, to be composed of hundreds of plant species arranged in precise relationships of shade, soil, and moisture that mimic the structure of the primary forest while producing food, medicine, and materials for Kayapó communities.\n\nThe system is not agriculture in the Western sense. It does not involve clearing, ploughing, or monoculture. It involves the meticulous management of complexity — an approach that produces lower yields per hectare than industrial farming but requires no inputs, produces no waste, and has maintained soil health in the same locations for generations.\n\nThe documentation of this knowledge has become urgent. Kayapó communities are under intense pressure from agricultural expansion, illegal logging, and mining. The knowledge-holders are elderly. And the knowledge, unlike the land, cannot simply be restored once lost.",
    category_index: 9,
    tag_indexes: [0, 9, 2],
    featured: false,
    published_at: 51.days.ago
  },
  {
    title: "The Night Sky Belongs to Everyone",
    excerpt: "Light pollution has made the Milky Way invisible to most people on Earth. A growing movement is fighting to get the dark back.",
    body: "Two-thirds of the world's population — and 99 percent of the population of Europe and the United States — lives under sky bright enough that the Milky Way is invisible. A child born in a major city today may grow to adulthood without ever seeing more than a few dozen stars.\n\nThis is historically unprecedented. For most of human history, the night sky was a constant presence — a navigation system, a calendar, a mythology, a source of wonder available to everyone. The loss of it has happened in less than a century, accelerated by the shift to LED lighting, which, while more energy-efficient, emits more blue-spectrum light and is therefore more disruptive to both human circadian rhythms and wildlife.\n\nThe International Dark-Sky Association has designated 195 dark-sky parks and reserves worldwide — places where outdoor lighting is regulated to protect the natural night sky. In these places, visitors can see the Milky Way as their ancestors saw it. The experience is, many report, genuinely shocking: not just beautiful but disorienting, in the way of encountering something vast that you had been told was ordinary.\n\n\"We have stolen something from people without asking,\" says astronomer Fabio Falchi. \"A basic human experience — looking up and seeing the universe — has been taken away from almost everyone alive.\"",
    category_index: 3,
    tag_indexes: [15, 9, 7],
    featured: false,
    published_at: 52.days.ago
  },
  {
    title: "The Art of Difficult Conversations",
    excerpt: "What negotiators, therapists, and hostage negotiators have learned about how to talk across disagreement.",
    body: "In the 1970s, the Harvard Negotiation Project produced a framework for resolving disputes that has since been taught to diplomats, mediators, managers, and anyone who has read the business section of an airport bookshop. The framework's central insight — separate the people from the problem — sounds straightforward and is, in practice, extremely difficult.\n\nThe difficulty is biological. When we feel disagreed with, our nervous system treats the disagreement as a threat, activating the same physiological responses as physical danger. Heart rate increases. Peripheral thinking narrows. The ability to consider the other person's perspective — already limited by what psychologists call the fundamental attribution error — is further degraded.\n\nRecent research in the psychology of difficult conversations has produced more nuanced tools. Motivational interviewing, developed by William Miller for use in addiction treatment, has been shown to work in contexts from climate activism to political persuasion. The technique involves asking open questions, reflecting back what the other person has said, and — crucially — not arguing for your own position until you have fully understood theirs.\n\n\"People change their minds when they feel heard, not when they are defeated,\" says conflict mediator Kenneth Cloke. \"The goal of a difficult conversation is not to win. It is to be understood and to understand.\"",
    category_index: 19,
    tag_indexes: [6, 2, 11],
    featured: false,
    published_at: 53.days.ago
  },
  {
    title: "The Long Life of a Short Film",
    excerpt: "How experimental cinema found an audience it never expected on the internet — and what this means for the art form.",
    body: "In 1929, Luis Buñuel and Salvador Dalí made a seventeen-minute film called Un Chien Andalou. It had no plot, no characters in the conventional sense, and no narrative logic — it was constructed, Buñuel later claimed, by writing down dreams and assembling them into a sequence that rejected rational connection.\n\nThe film was received, on its Paris premiere, with a mixture of bafflement and acclaim. It has been studied by film students ever since. But it found a genuinely mass audience only in the twenty-first century, when it became one of the most-viewed short films on early YouTube — watched not by film scholars but by teenagers who had been told it contained a notorious eyeball-slicing scene and wanted to see it for themselves.\n\nThe YouTube audience did not watch the film in the way Buñuel intended. They watched it as a novelty, a shock object, a piece of surrealism that functioned as meme material. But they watched it — and some of them kept watching, and some of those became interested in surrealist cinema more broadly.\n\n\"Experimental cinema has always needed unlikely intermediaries,\" says film historian Laura Mulvey. \"The internet is the strangest intermediary yet. But it seems to be working.\"",
    category_index: 13,
    tag_indexes: [3, 18, 6],
    featured: false,
    published_at: 54.days.ago
  },
  {
    title: "The Hidden Language of Hands",
    excerpt: "Sign languages are not translations of spoken languages. They are complete, independent linguistic systems — and they are disappearing.",
    body: "There are an estimated 300 distinct sign languages in the world, and most of them have no official recognition, no standardised writing system, and no more than a few thousand users. Linguists who study them are racing against a particular kind of extinction: the consolidation of Deaf communities into a handful of dominant sign languages, driven by globalisation and the dominance of national educational systems.\n\nThe loss would be significant beyond the Deaf communities directly affected. Sign languages have provided linguistics with some of its most important evidence about the universality of language structure. Because they evolved independently of spoken languages — on different substrates, using different modalities — they offer a kind of natural experiment in how language develops when the usual constraints are removed.\n\nThe findings have been striking. Sign languages have the same basic grammatical structures as spoken languages: subjects, objects, verbs, tense, aspect, mood. They have syntax, not just vocabulary. They tell jokes. They tell lies. They have accents and dialects and slang.\n\n\"Every sign language is a complete language,\" says linguist Diane Brentari. \"The surprise is not that they resemble spoken languages. The surprise is how deeply similar all languages are, spoken or signed, when you look below the surface.\"",
    category_index: 0,
    tag_indexes: [0, 2, 7],
    featured: false,
    published_at: 55.days.ago
  },
  {
    title: "The Rise of the Amateur Scientist",
    excerpt: "Citizen science has moved from birdwatching to galaxy mapping. What happens when millions of non-experts join the scientific enterprise?",
    body: "In 2007, astronomers at Yale uploaded 893,212 images from the Sloan Digital Sky Survey to a website called Galaxy Zoo and asked members of the public to classify them. They expected to wait months for the results. In the first hour, volunteers were classifying 70,000 galaxies per hour. Within the year, more than 150,000 people had submitted classifications. The resulting dataset was more complete and more accurate than any automated system available at the time.\n\nGalaxy Zoo was neither the first nor the last citizen science project to produce results that professional researchers could not have achieved alone. The Christmas Bird Count, run by the Audubon Society, has been collecting bird population data since 1900 — the longest continuous wildlife survey in existence. iNaturalist, a platform where users upload observations of plants and animals with GPS coordinates, has accumulated more than 100 million observations from 3 million users and has become a primary data source for biodiversity research.\n\nThe implications for science are significant and not entirely comfortable. Citizen science is cheap, scalable, and produces data at resolutions that professional researchers cannot afford. It also introduces questions about data quality, incentive structures, and the relationship between expert and amateur knowledge that the scientific community is still working through.\n\n\"The line between professional and amateur has always been fuzzier than it appears,\" says science historian Steven Shapin. \"Citizen science is not new. What is new is the scale and the infrastructure.\"",
    category_index: 3,
    tag_indexes: [7, 9, 2],
    featured: false,
    published_at: 56.days.ago
  },
  {
    title: "The Last Great Bookshops",
    excerpt: "Independent booksellers have survived the internet, Amazon, and a pandemic. Here is how they did it.",
    body: "Shakespeare and Company, on the Left Bank of Paris, was founded by Sylvia Beach in 1919. It closed during the German occupation and reopened, in a different location, in 1951. It has been there ever since, selling English-language books in a city where English-language books are not the natural commercial proposition, defying every prediction of its imminent demise.\n\nThe shop's survival is partly explained by its mythology — it is the bookshop where Hemingway browsed and Joyce was first published — but mythology alone does not pay rent. Shakespeare and Company has survived because it has consistently offered something that Amazon cannot: a place where books are curated by people who have read them, who can talk about them, who can connect a customer's vague description of what they are looking for to the exact book they didn't know existed.\n\nThis capacity — call it bibliographic serendipity — turns out to be extremely difficult to replicate algorithmically. Amazon's recommendation engine is good at telling you what people who bought what you bought also bought. It is not good at telling you what you should read next if you are feeling melancholy on a Tuesday afternoon and want something that will make the world feel larger.\n\n\"The great bookshop is a conversation,\" says bookseller Shaun Bythell. \"It requires a human on both sides.\"",
    category_index: 12,
    tag_indexes: [8, 7, 2],
    featured: false,
    published_at: 57.days.ago
  },
  {
    title: "Inside the Mind of a Migratory Bird",
    excerpt: "How birds navigate across continents without GPS, maps, or any external reference that scientists have been able to fully identify.",
    body: "The bar-tailed godwit flies non-stop from Alaska to New Zealand — a journey of 11,000 kilometres over nine days, without eating, drinking, or landing. It does this every year. It navigates to within metres of its destination using systems that biologists are only beginning to understand.\n\nWhat we know is this: birds use multiple overlapping navigation systems, of which the magnetic compass is probably the most important. Cryptochrome proteins in the retina appear to allow birds to literally see the Earth's magnetic field — not as a visual phenomenon but as a directional sense overlaid on normal vision. They also use the position of the sun, the pattern of stars, and possibly infrasound — low-frequency sound waves produced by ocean waves and topographic features that travel thousands of kilometres.\n\nThe system is robust to perturbation in a way that GPS is not. Experiments that disrupt one navigation cue find that birds compensate by relying more heavily on others. The redundancy appears to be a feature rather than a bug — a reliability mechanism for a journey where failure is fatal.\n\n\"We have spent decades trying to understand how they do it,\" says ornithologist Richard Holland. \"Each answer reveals three more questions. The bird, apparently, does not find this complicated.\"",
    category_index: 3,
    tag_indexes: [0, 7, 11],
    featured: false,
    published_at: 58.days.ago
  },
  {
    title: "The Fashion Houses That Last",
    excerpt: "In an industry defined by novelty, a handful of houses have survived for more than a century. What do they know that others don't?",
    body: "Hermès was founded in 1837 as a harness maker for the French cavalry. It became a luggage maker when the cavalry became obsolete. It became a silk scarf company when luggage became commodified. It became a handbag company — the Birkin, the Kelly — when silk became commodified. It is now worth approximately €240 billion and has a waiting list for its products measured in years.\n\nThe Hermès story is not unique. Chanel was founded in 1909 as a millinery. Louis Vuitton in 1854 as a trunk maker. These companies have survived world wars, depressions, social revolutions, and the disruption of every market they have operated in, and they have survived by doing the same thing each time: identifying what they do that cannot be copied, and retreating to it.\n\nWhat they do that cannot be copied, it turns out, is not the product. It is the story. The Birkin bag is made from leather and metal. The waiting list and the price — upward of $30,000 for basic models — are made from narrative. From the story of craft, exclusivity, and enduring value that Hermès has maintained with absolute consistency for nearly two centuries.\n\n\"Luxury is not about the object,\" says fashion historian Valerie Steele. \"It is about the belief in the object. The great houses sell that belief more reliably than anything else.\"",
    category_index: 6,
    tag_indexes: [17, 2, 7],
    featured: false,
    published_at: 59.days.ago
  },
  {
    title: "What a Hospital at Night Sounds Like",
    excerpt: "A nurse's account of the sounds, silences, and small dramas of the overnight shift.",
    body: "The hospital changes at night. The administrators go home, the consultants go home, the visitors go home, the noise of the day — the trolleys, the announcements, the visiting hours — subsides, and what is left is the essential institution: the patients, the nurses, and the particular quality of silence that is never quite silent.\n\nI have worked the night shift for eleven years. I prefer it. There is a clarity to night nursing that the day obscures. The hierarchy flattens slightly. The paperwork recedes. You are, more nakedly than during the day, a person caring for another person.\n\nThe sounds of the night ward are distinctive: the rhythmic percussion of ventilators, the soft alert of IV pumps, the particular cry that means pain and the particular cry that means fear and the particular silence that means something else. You learn to read these sounds the way a musician reads a score. The information is in the variations.\n\nI think about what a hospital is, sometimes, in the quiet hours between two and four. It is the place where the body becomes the whole problem. Everything else — status, money, opinion — disappears. The body remains. We try to help it. Sometimes we succeed. Sometimes the night teaches you the limits of helping.",
    category_index: 7,
    tag_indexes: [16, 0, 14],
    featured: false,
    published_at: 60.days.ago
  },
  {
    title: "The Paradox of Progress",
    excerpt: "Every generation believes it is living through unprecedented change. For once, they may be right.",
    body: "In 1900, a horse-drawn carriage could travel from New York to Chicago in approximately two weeks. By 1930, a car could make the journey in four days. By 1960, a commercial aircraft covered it in three hours. By 2000, the time had not changed — the airliner was already near its ceiling — and the principal experience of long-distance travel became not the journey but the airport.\n\nThis pattern — rapid initial transformation followed by a plateau — recurs throughout technological history. The steam engine, the telephone, the automobile, the computer: each produced a period of radical change followed by decades of incremental improvement within a stable paradigm.\n\nThe question for our own moment is where we are in this cycle. The optimists argue that we are at the beginning of a transformation — artificial intelligence, biotechnology, clean energy — that will dwarf the industrial revolution in its scope. The pessimists argue that we have been making this claim since at least the 1970s and that the productivity data does not support it.\n\nBoth sides agree on one thing: the question is more consequential than most questions we ask. If the optimists are right, the institutions we have built to manage technological change will be inadequate. If the pessimists are right, the institutions we have built on the assumption of unlimited growth face a reckoning.",
    category_index: 8,
    tag_indexes: [6, 2, 10],
    featured: false,
    published_at: 61.days.ago
  },
  {
    title: "The Dancers Who Changed What Ballet Could Be",
    excerpt: "How a generation of choreographers broke ballet's codes — and why the form they found keeps producing new work.",
    body: "In 1913, The Rite of Spring caused a riot. The audience at the Théâtre des Champs-Élysées in Paris booed, hissed, and eventually exchanged blows over Stravinsky's music and Nijinsky's choreography. The spectacle of dancers moving with turned-in feet, hunched posture, and percussive force was, to the audience raised on the smooth vertical line of classical ballet, an act of violence against the form.\n\nBy 1960, The Rite of Spring was canonical. By 2000, its innovations were the basis of contemporary dance. The story of modernism in ballet is a story of repeated offenses that became conventions, of shocks that became traditions.\n\nThe current generation of choreographers has inherited this process and, in some ways, completed it. There is no longer a classical norm against which contemporary work defines itself as transgression. The question now is what ballet becomes when transgression is no longer available as an aesthetic strategy.\n\nThe answers have been various and often surprising. William Forsythe's geometrical deconstructions. Ohad Naharin's Gaga technique. Crystal Pite's synthesis of ballet vocabulary with physical theatre. All represent attempts to find, in the form's formal resources, new possibilities that are genuinely internal rather than reactions against a tradition.\n\n\"We are no longer against something,\" says choreographer Akram Khan. \"We have to be for something. That is harder.\"",
    category_index: 0,
    tag_indexes: [17, 3, 7],
    featured: false,
    published_at: 62.days.ago
  },
  {
    title: "The Physics of a Perfect Cup",
    excerpt: "Coffee science has become serious science. What researchers have discovered about extraction, temperature, and grind.",
    body: "The perfect espresso is, from a physicist's perspective, a problem in fluid dynamics. Hot water under nine bars of pressure passes through a bed of compacted, finely ground coffee, extracting soluble compounds at different rates depending on particle size, water temperature, and the time the water spends in contact with the grounds. The ideal extraction — the one that produces the most desirable flavour balance — occurs in a window of roughly twenty to thirty seconds, in a temperature range of 90 to 96 degrees Celsius, with a grind distribution that optimises surface area while avoiding channels.\n\nThe science is not new — baristas have known most of this empirically for decades — but its formalisation has changed what is possible. Research published in the journal Matter in 2019 showed that using slightly coarser grind and slightly less coffee produces more consistent, better-tasting espresso — counterintuitive findings that led to a rethinking of extraction theory in commercial settings.\n\nThe coffee industry's engagement with science has also revealed how much of what people taste is contextual rather than chemical. Studies consistently show that coffee served in a pleasant environment, by an engaged barista, is rated more highly than identical coffee served in neutral conditions. The cup is only part of the experience.\n\n\"Coffee is chemistry,\" says food scientist Christopher Hendon. \"But whether you enjoy it is psychology. Both matter enormously.\"",
    category_index: 5,
    tag_indexes: [2, 11, 7],
    featured: false,
    published_at: 63.days.ago
  },
  {
    title: "The Architecture of Power",
    excerpt: "From Egyptian temples to modern parliaments, the way we build our political spaces shapes the politics conducted within them.",
    body: "The United States Capitol was designed, in 1793, to communicate a specific idea: that American democracy was the legitimate heir of the Roman Republic. The building's dome, its columns, its formal axial symmetry — all derive from the architectural grammar of antiquity, chosen deliberately to associate the new nation with the greatest democracy the ancient world had produced.\n\nThe buildings in which politics is conducted are never neutral. The cramped debating chamber of the UK House of Commons — a rectangle so narrow that government and opposition benches are two sword-lengths apart, a design inherited from a medieval chapel — produces a confrontational, adversarial style of debate that is genuinely different from the semicircular arrangement of the European Parliament, which tends toward negotiation and coalition-building.\n\nThe research on this is surprisingly robust. Experimental studies show that people make different decisions depending on the height of the ceiling above them, the ambient noise level, the presence or absence of natural light, and the arrangement of furniture in the room. Political decisions are not made in a vacuum — they are made in buildings, and buildings have consequences.\n\n\"Architecture is the most political of the arts,\" says architect Deyan Sudjic. \"It cannot be experienced privately. It is always public, always shared, always an argument about how we should live together.\"",
    category_index: 16,
    tag_indexes: [2, 7, 17],
    featured: false,
    published_at: 64.days.ago
  },
  {
    title: "The Afterlife of Images",
    excerpt: "Most photographs are never seen. What happens to the billions of images produced every year that vanish into hard drives and cloud servers?",
    body: "In 2023, approximately 1.72 trillion photographs were taken worldwide. The number is almost impossible to apprehend. It is roughly 217,000 images per second, or 1.8 billion per day, or enough photographs, printed as 4x6 prints, to cover the surface of the Earth sixteen times.\n\nMost of them will never be seen by anyone other than the person who took them. A substantial proportion will be seen only once — glanced at, dismissed, forgotten. The great majority will be absorbed into the perpetual archive of cloud storage and survive indefinitely, though unviewed, in server farms consuming vast quantities of electricity in service of collective amnesia.\n\nThe photographer and theorist Joan Fontcuberta has called this the \"post-photographic condition\" — a world in which the production of images has become so effortless and so universal that the image has lost its evidential and emotional weight. When everyone photographs everything, what does it mean to photograph something?\n\nThe paradox, Fontcuberta argues, is that the proliferation of images has made individual images more rather than less significant — not because of their rarity but because of the difficulty of making any single image stand out from the torrent. The challenge of contemporary photography is not to make images. It is to make images that matter.",
    category_index: 15,
    tag_indexes: [6, 2, 19],
    featured: false,
    published_at: 65.days.ago
  },
  {
    title: "The Teenagers Saving Languages",
    excerpt: "Around the world, young people are using social media to document and revive endangered languages that their grandparents still speak.",
    body: "Māmaka Kahanamoku is twenty-three years old and speaks Hawaiian as her first language. This makes her unusual: Hawaiian was effectively extinct as a community language by the 1980s, with fewer than a thousand speakers remaining, almost all elderly. Today there are approximately 18,000 speakers, and the number is growing. Kahanamoku is part of the generation that grew up in Hawaiian-language immersion schools, and she is now using TikTok to teach the language to a generation that didn't.\n\nThe phenomenon is not confined to Hawaiian. Welsh teenagers are making YouTube videos in Welsh. Young Māori are using Instagram to document traditional knowledge in te reo Māori. Young speakers of Occitan, Cornish, Basque, and dozens of other minority languages are using platforms designed for English-language content to create spaces in which their languages can live.\n\nThe results are mixed but encouraging. Social media reaches young people in ways that formal language education cannot. It destigmatises minority languages by associating them with contemporary content. And it creates, for the first time, a record of everyday language use — jokes, arguments, slang, code-switching — that linguists have never before had access to at scale.\n\n\"Languages need speakers,\" says linguist David Crystal. \"The internet doesn't save languages. Speakers do. But the internet connects speakers who might otherwise never have met.\"",
    category_index: 0,
    tag_indexes: [7, 9, 13],
    featured: false,
    published_at: 66.days.ago
  },
  {
    title: "When Algorithms Write the News",
    excerpt: "Automated journalism is already producing millions of articles per year. What does it mean for the practice of reporting?",
    body: "The Associated Press has been using automated journalism software to produce earnings reports since 2014. The software — built by a company called Automated Insights — takes structured financial data and converts it into prose at a rate of approximately 4,400 stories per quarter, a volume that would require dozens of human journalists to match.\n\nThe stories are accurate, appropriately hedged, and indistinguishable, in most readers' experience, from stories written by humans. They are also, critics argue, narrowly useful. They convey information that the numbers already contained. They do not ask why the numbers are what they are, what they mean in context, whether the company is telling the truth, or what a worker on the floor of the factory thinks about the quarterly results.\n\nThe distinction maps onto a distinction in journalism that has always existed but was previously theoretical: the difference between information transfer and accountability. Automated journalism is excellent at the former. It is, by definition, incapable of the latter.\n\nThis would matter less if automated journalism were replacing only the most mechanical forms of human journalism. The concern, among reporters and editors, is that it is replacing the journalism that pays for accountability journalism — the commodity content that subsidises the expensive, time-consuming work of investigation.\n\n\"The economics are simple,\" says media analyst Ken Doctor. \"Why pay a journalist to write an earnings report when a machine does it better? The problem is what you lose when you stop paying journalists for anything.\"",
    category_index: 19,
    tag_indexes: [2, 10, 9],
    featured: false,
    published_at: 67.days.ago
  },
  {
    title: "The Neuroscience of Creativity",
    excerpt: "For decades, we thought creativity lived in the right brain. The truth is stranger and more distributed.",
    body: "The left brain / right brain theory of creativity is wrong. It was never well supported by the evidence — the research it was drawn from concerned the coordination of hand movements, not the production of ideas — and decades of neuroimaging have not found the clean hemispheric division that the popular account requires.\n\nWhat neuroscience has found is more interesting. Creativity appears to involve the interaction of three large-scale brain networks: the default mode network (which produces spontaneous, associative thought), the executive control network (which focuses attention and evaluates ideas), and the salience network (which switches between the two).\n\nHighly creative people appear to have stronger connections between these networks — particularly between the default mode and executive control networks, which in most people are anticorrelated: when one is active, the other is quiet. The creative brain, it seems, is one that can hold spontaneous generation and critical evaluation simultaneously rather than sequentially.\n\nThis explains a phenomenon that creative people often describe: the feeling of being an observer of their own creativity, of ideas arriving unbidden and being assessed by what feels like a separate faculty. It also has practical implications: the conditions that suppress the default mode network — stress, distraction, the pressure to perform — are precisely the conditions that suppress creativity.\n\n\"You cannot think your way to a good idea,\" says neuroscientist Rex Jung. \"You can only create conditions in which good ideas are likely to arrive.\"",
    category_index: 3,
    tag_indexes: [2, 11, 7],
    featured: false,
    published_at: 68.days.ago
  },
  {
    title: "The Quiet Power of Textile Art",
    excerpt: "Weaving, embroidery, and quilting have been dismissed as craft. A generation of artists is changing that.",
    body: "The Feminist Art movement of the 1970s made a strategic decision to rehabilitate craft as art — to argue that the quilts, needlework, and weaving that women had produced for centuries deserved the same critical attention as the painting and sculpture that men had produced. The argument was both aesthetic and political: these were significant works that had been rendered invisible by a critical establishment that associated the handmade with the domestic.\n\nFifty years later, the rehabilitation is incomplete but proceeding. The Bard Graduate Center in New York has a department dedicated to the decorative arts. The Metropolitan Museum of Art has textile galleries with serious scholarly apparatus. Major contemporary artists — Kara Walker, Grayson Perry, El Anatsui — work with textiles or in textile traditions and show in the most prestigious contemporary art contexts.\n\nWhat textile art offers, that painting and sculpture do not always offer, is a particular relationship between maker and material. Thread must be handled differently from paint. Warp and weft impose constraints that the canvas does not. The history of the material — who made cloth like this, and why, and under what conditions — is present in a way that the history of paint pigments usually is not.\n\n\"Textiles carry culture in a way that almost no other material does,\" says curator Glenn Adamson. \"You cannot look at a Kente cloth and ignore the society that produced it. The social is woven in.\"",
    category_index: 10,
    tag_indexes: [17, 7, 6],
    featured: false,
    published_at: 69.days.ago
  },
  {
    title: "Notes on Leaving Home",
    excerpt: "More people are living outside their country of birth than at any point in recorded history. What does diaspora mean in the age of WhatsApp?",
    body: "My grandmother left Kerala for London in 1969. She carried two suitcases and a shortwave radio through which she could, on good nights, hear Malayalam-language broadcasts from All India Radio. Contact with home required letters that took three weeks and international telephone calls that cost the equivalent of a day's wages per minute.\n\nMy cousins left Kerala for London, Dubai, and Toronto between 2015 and 2020. They communicate with family through WhatsApp groups, watch Malayalam films on streaming services, order food from websites that deliver imported groceries, and are never, in any meaningful sense, out of contact with home.\n\nThe experience of diaspora has been transformed by connectivity in ways that social scientists are still measuring. Traditional models of immigrant assimilation assumed that contact with the homeland would diminish over time as migrants integrated into the host country. The data suggests this is no longer true: sustained digital contact with home communities is associated with slower cultural assimilation and stronger maintenance of home-country identity — which may be good or bad depending on your perspective.\n\nWhat is clear is that the psychology of leaving — the grief of departure, the disorientation of arrival, the gradual building of a life in a new place — is being fundamentally altered by the fact that departure is no longer absolute. Home is always a phone call away. The question is what that does to the idea of home itself.",
    category_index: 4,
    tag_indexes: [16, 6, 0],
    featured: false,
    published_at: 70.days.ago
  },
  {
    title: "The Slow Death of the Office",
    excerpt: "The pandemic accelerated a crisis that was already coming. What happens to cities built around commuting?",
    body: "In the summer of 2023, the occupancy rate of office buildings in San Francisco's financial district averaged 43 percent. In Manhattan, it was 47 percent. In London, 51 percent. In Tokyo, which has the highest office occupancy rate of any major city, it was 68 percent — still substantially below pre-pandemic levels.\n\nThese numbers represent a structural shift in urban economies that mayors, developers, and transit authorities are only beginning to reckon with. The commercial real estate model that has underpinned urban development for a century — office buildings full five days a week, workers eating lunch and shopping and using transit services that wouldn't exist without them — is under stress in every major Western city.\n\nThe consequences extend beyond empty office towers. Transit systems built on the assumption of predictable weekday peaks are haemorrhaging revenue. Small businesses that catered to office workers — sandwich shops, dry cleaners, coffee shops near office districts — have closed in large numbers and have not been replaced. Tax revenues from commercial property have declined significantly in the cities most affected.\n\n\"The city is a network of networks,\" says urban economist Ed Glaeser. \"When you remove one of the central nodes — the office — the whole network changes. Some of the changes will be beneficial. Most will be complicated.\"",
    category_index: 8,
    tag_indexes: [2, 9, 11],
    featured: false,
    published_at: 71.days.ago
  },
  {
    title: "The Poet Who Became a Diplomat",
    excerpt: "Pablo Neruda, Léopold Sédar Senghor, Wole Soyinka — the tradition of the writer in public life has a complicated history.",
    body: "Pablo Neruda served as Chilean consul in Rangoon, Barcelona, and Madrid before becoming a senator and ambassador. Léopold Sédar Senghor founded a school of African literary thought before becoming the first president of Senegal and serving for two decades. Wole Soyinka, Nigeria's first Nobel laureate, spent two years in solitary confinement under the Gowon regime for attempting to negotiate peace during the Biafran war.\n\nThe tradition of the politically engaged writer — the writer who enters public life not as a commentator but as a participant — is ancient and has produced some of history's most significant literature and some of its most sobering cautionary tales. The question of whether political engagement improves or damages creative work has no clear answer; the evidence for both positions is extensive.\n\nWhat is clear is that the cultural authority of writers in public life has declined in most Western democracies. The age of the public intellectual — when figures like Sartre, Camus, or Bertrand Russell could command genuine public attention on political questions — has passed, replaced by the age of the pundit, whose authority derives from institutional affiliation rather than literary achievement.\n\n\"The writer's authority is moral, not institutional,\" says critic James Wood. \"When writers enter political institutions, they trade one kind of authority for another, and usually get the worse deal.\"",
    category_index: 12,
    tag_indexes: [6, 17, 2],
    featured: false,
    published_at: 72.days.ago
  },
  {
    title: "The Science of Soil",
    excerpt: "A teaspoon of healthy soil contains more organisms than there are people on Earth. We are only beginning to understand what they do.",
    body: "The agricultural revolution was built on a misunderstanding. For ten thousand years, farmers have treated soil as a medium — a substrate in which to anchor plant roots and deliver nutrients. The Green Revolution of the twentieth century intensified this misunderstanding: by providing plants with synthetic fertilisers, it made the biological activity of soil seem unnecessary.\n\nThe science of the past three decades has revealed what was lost. Healthy soil is not a substrate but an ecosystem — a complex community of bacteria, fungi, nematodes, earthworms, and thousands of other organisms that create the conditions for plant growth through interactions so intricate that we have mapped only a fraction of them.\n\nThe mycorrhizal networks — the web of fungal filaments that connects plant roots across hectares of forest floor — are perhaps the most discussed of these interactions. Plants trade sugars for minerals with their fungal partners; the exchange is so significant that a forest's carbon economy cannot be understood without accounting for it.\n\nBut the mycorrhizae are one component of a system of almost incomprehensible complexity. Agricultural soils, stripped of biodiversity by tillage, chemical treatment, and monoculture, may be producing food at the cost of their own long-term capacity to produce food.\n\n\"We have been mining soil,\" says agroecologist David Montgomery. \"Not farming it. The distinction will matter very much in the coming decades.\"",
    category_index: 9,
    tag_indexes: [7, 11, 9],
    featured: false,
    published_at: 73.days.ago
  },
  {
    title: "The Rise of Endurance Sport",
    excerpt: "More people are running marathons, cycling centuries, and swimming channels than at any point in history. Why?",
    body: "In 1972, approximately 1,000 people ran the New York City Marathon. In 2024, the lottery to enter received 145,000 applications for 50,000 slots. The marathon — once a specialist athletic event that required years of dedicated training — has become a mass participation phenomenon.\n\nThe same shift has occurred across endurance sport. Iron-distance triathlons, which require a 2.4-mile swim, 112-mile bike ride, and 26.2-mile run in a single day, now attract participants who are not competitive athletes and have no ambition to win — only to finish. Ultra-marathons, which cover distances of 50 to 100 miles or more through mountainous terrain, have grown from a fringe interest to a mainstream aspiration.\n\nThe explanations for this are several. Endurance sport provides a legible structure for achievement in a world where many traditional structures — career advancement, property ownership, family formation — have become less accessible or less reliable as sources of meaning. The marathon is hard in a measurable, trainable way: effort is rewarded, progress is visible, completion is unambiguous.\n\nThere is also, researchers suggest, a social dimension. Endurance events are communities as much as competitions — communities defined by shared effort, common suffering, and an identity that is immediately meaningful to others who share it.\n\n\"We evolved to run,\" says evolutionary biologist Daniel Lieberman. \"The question is not why so many people are doing it. It is why it took so long to happen.\"",
    category_index: 11,
    tag_indexes: [7, 9, 2],
    featured: false,
    published_at: 74.days.ago
  },
  {
    title: "What Happens After the Algorithm",
    excerpt: "Social media companies built systems to maximise engagement. Now they are discovering what they created.",
    body: "In 2016, a Facebook engineer sent a memo to the company's leadership. It noted that the recommendation algorithms were producing what the memo called \"content with high arousal value\" — content that provoked anger, fear, and outrage. It noted that users engaged with this content more than with calming or neutral content. It recommended changes to the recommendation system that would reduce the prioritisation of high-arousal content. The recommendation was not adopted.\n\nThe memo, leaked in the 2021 Facebook Papers, is one data point in a growing body of evidence about the relationship between algorithmic recommendation and political polarisation, mental health, and the information environment. The evidence is contested — the causal links are difficult to establish, and some studies find smaller effects than others — but the direction is consistent.\n\nWhat is less contested is the mechanism. Recommendation algorithms optimise for engagement. Engagement is maximised by content that provokes strong emotional responses. Strong emotional responses are, disproportionately, negative: anger, fear, and outrage engage more reliably and more intensely than their positive counterparts. A system that maximises engagement will, ceteris paribus, maximise the distribution of content that makes people angry and afraid.\n\n\"No one designed the outrage machine,\" says technology critic Tristan Harris. \"It emerged from incentives. Changing it requires changing the incentives — which means changing the business model.\"",
    category_index: 1,
    tag_indexes: [2, 10, 9],
    featured: false,
    published_at: 75.days.ago
  },
  {
    title: "The Civilisation Inside a Coral Reef",
    excerpt: "The Great Barrier Reef is the largest living structure on Earth. Understanding it is one of science's great ongoing projects.",
    body: "The Great Barrier Reef extends for 2,300 kilometres along the northeast coast of Australia, covering an area larger than Italy. It is composed of approximately 600 types of hard and soft coral, 4,000 species of mollusc, 1,625 species of fish, 133 species of shark and ray, and six of the world's seven species of sea turtle. It is also, in a more fundamental sense, a single organism — a community of relationships so interwoven that removing one element changes everything else.\n\nThe reef has been bleaching — a stress response in which coral expels its symbiotic algae and turns white, eventually dying if conditions do not improve — with increasing frequency and severity. The cause is ocean warming driven by climate change. The 2016 and 2017 bleaching events killed more than half of the coral in the northern reef system. The 2020 and 2022 events extended the damage further south.\n\nMarine biologists at the Australian Institute of Marine Science are working on interventions that range from assisted evolution — selectively breeding heat-tolerant coral — to large-scale cooling of reef areas using fog-generation systems. The work is extraordinary in its ambition and uncertain in its prospects.\n\n\"We are trying to manage the consequences of a problem we have not yet solved,\" says reef scientist Ove Hoegh-Guldberg. \"Buying time is not the same as solving the problem. But buying time may be all we can do right now.\"",
    category_index: 9,
    tag_indexes: [7, 9, 0],
    featured: true,
    published_at: 76.days.ago
  },
  {
    title: "The Winemakers Chasing Altitude",
    excerpt: "As climate change warms traditional wine regions, vintners are planting higher and further north than ever before.",
    body: "The vineyards of Burgundy have been producing wine since the monks of the Cistercian order began planting them in the twelfth century. The monks chose their locations with extraordinary care — mapping the soil, the microclimate, the drainage, and the angle of the sun over generations — and the result is the most precisely mapped wine terroir in the world, a patchwork of individual plots each producing wine of distinct character.\n\nThe problem is that the climate the monks calibrated for no longer exists. Average temperatures in the Côte d'Or have risen by approximately 2 degrees Celsius since 1950. Grapes are ripening earlier, producing higher sugar levels and lower acidity — making wines that are less structured, less age-worthy, and, in the judgement of many wine critics, less interesting.\n\nThe response has been varied. Some producers are harvesting earlier to preserve acidity. Some are planting on north-facing slopes that were previously too cold. Some are experimenting with grape varieties that would have been unsuitable for their appellations twenty years ago.\n\nAnd some are moving to higher altitudes — planting in the Alps, in the Pyrenees, in the mountains of northern Spain and Portugal — chasing the temperatures that the lowland vineyards have lost. The wines produced in these places are different from the classics they are not trying to replace. Whether they are as good is a question that will take decades to answer.",
    category_index: 5,
    tag_indexes: [7, 9, 2],
    featured: false,
    published_at: 77.days.ago
  },
  {
    title: "The Men Who Make Watches by Hand",
    excerpt: "In a world of mass production and disposable goods, a handful of craftspeople still make watches that take a year to build.",
    body: "The movement of a mechanical watch — the assembly of gears, springs, levers, and jewels that converts the energy of a wound mainspring into the regular tick of seconds — is one of the most intricate objects that human hands have produced. A complicated watch may contain five hundred separate components, each machined to tolerances measured in microns, assembled in a sequence that requires years of training to master.\n\nThe industrial revolution automated most of this work. Swiss manufacturers like Rolex and Patek Philippe retain hand-finishing — the polishing of surfaces, the bevelling of edges — as a mark of quality, but the components are machined, not handmade. True hand-production, from raw metal to finished watch, is the province of a tiny number of independent watchmakers who produce perhaps twenty watches per year and have waiting lists of a decade or more.\n\nThese makers — George Daniels, who died in 2011, was the most celebrated; his successors include Roger Smith and a handful of others — are motivated by something that market forces do not explain. They could earn more, work less, and live more comfortably doing almost anything else.\n\n\"A watch is a philosophical object,\" says watchmaker Philippe Dufour. \"It is a machine that measures time using only mechanical means, with no external reference. To make one is to understand what time is — which is to say, to understand how little we know about what time is.\"",
    category_index: 10,
    tag_indexes: [8, 14, 7],
    featured: false,
    published_at: 78.days.ago
  },
  {
    title: "The Election That Changed Everything",
    excerpt: "How a single referendum reshaped a country's political landscape for a generation — and what it teaches about democratic decision-making.",
    body: "The Brexit referendum of 2016 was, by most measures, a democratic event of unusual clarity. A clear question — Leave or Remain — was put to the electorate. A clear answer was returned. A decision was made.\n\nThe consequences have been correspondingly clear: significant disruption to trade with the United Kingdom's largest trading partners, a loss of freedom of movement for British citizens in Europe and European citizens in Britain, a political realignment that reshuffled the major parties, and a constitutional crisis in Northern Ireland that is still unresolved.\n\nWhat the Brexit case illustrates — and what democratic theorists have been debating since it happened — is the tension between democratic procedure and democratic outcome. The referendum was procedurally democratic. Whether the outcome has been democratically beneficial is a question on which the evidence continues to accumulate, and on which reasonable people continue to disagree.\n\nThe deeper question concerns the appropriate scope of referendums as instruments of democratic decision-making. Complex, multi-dimensional questions — Should this country leave this particular political and economic union, with all the trade-offs that entails? — may be poorly suited to binary choice mechanisms designed for simpler decisions.\n\n\"The referendum answered one question,\" says political scientist Matthew Goodwin. \"It raised a hundred others. That ratio is not ideal.\"",
    category_index: 2,
    tag_indexes: [2, 10, 9],
    featured: false,
    published_at: 79.days.ago
  },
  {
    title: "How Cities Decide What to Demolish",
    excerpt: "The politics of architectural preservation — who gets to say what survives, and what disappears.",
    body: "In 1963, New York's Pennsylvania Station was demolished. The building — a beaux-arts monument modelled on the Baths of Caracalla in Rome, one of the grandest public spaces in American history — was replaced by the existing Penn Station, widely regarded as one of the worst public buildings in the world. The demolition was carried out over the protests of a handful of architects and preservationists, and it prompted the passage of New York City's Landmarks Law in 1965, which created the framework for architectural preservation that now protects more than 35,000 buildings.\n\n\"We will probably be judged not by the monuments we build,\" wrote Ada Louise Huxtable in the New York Times after the demolition, \"but by those we have destroyed.\"\n\nThe politics of preservation are never simple. Buildings exist in cities, which are not museums. They occupy valuable land. They consume energy. They were designed for functions that change. The argument for demolishing a historic building is always that the city needs something the building cannot provide. The argument for preserving it is always that the city needs what the building cannot be replaced.\n\nThe resolution of this argument varies by city, by moment, and by who controls the process. London has lost more of its Victorian industrial buildings in the past thirty years than in the Victorian era's entire period of construction. Tokyo, which has no strong preservation movement, rebuilds its urban fabric almost entirely within a generation.",
    category_index: 16,
    tag_indexes: [17, 2, 7],
    featured: false,
    published_at: 80.days.ago
  },
  {
    title: "The Future of Work Is Already Here",
    excerpt: "In the gig economy's most extreme forms, workers have lost the protections of employment without gaining the freedom of self-employment.",
    body: "In 2024, approximately 59 million Americans — 36 percent of the workforce — reported doing some form of gig or freelance work. The number has grown steadily since the Great Recession of 2008, accelerated by the pandemic, and shows no sign of plateauing. The conventional employment relationship — one employer, stable hours, benefits, and the legal protections that come with employee status — is becoming a minority experience for younger workers in many sectors.\n\nThe optimistic case for gig work — freedom, flexibility, entrepreneurship — is well established in company communications and less well established in the research literature. Studies consistently show that most gig workers would prefer conventional employment if it were available at comparable wages. The \"flexibility\" of gig work frequently means availability at irregular hours for unpredictable income, which is not flexibility in any meaningful sense.\n\nThe policy response has been varied. California's Proposition 22, in 2020, created a third employment category — \"independent contractor plus\" — for app-based workers, providing some benefits without employment protections. The EU has proposed legislation that would reclassify most platform workers as employees. Neither approach has fully resolved the underlying tension between platform economics and worker welfare.\n\n\"The gig economy is not a new kind of work,\" says labour economist Lawrence Katz. \"It is a very old kind of work — piecework, casualisation, irregular income — with better branding.\"",
    category_index: 8,
    tag_indexes: [2, 10, 9],
    featured: false,
    published_at: 81.days.ago
  },
  {
    title: "The Mountain at the Edge of the World",
    excerpt: "Climbing Everest has become a managed commercial operation. What that means for the mountain — and for what mountaineering was.",
    body: "In 1953, Edmund Hillary and Tenzing Norgay reached the summit of Everest after months of logistical preparation, multiple high-altitude camps, and a final push that required everything they had. They were the first people to stand at the highest point on Earth.\n\nIn 2024, several hundred people reached the same summit during the spring climbing season. They were guided by professional operators, supported by fixed ropes installed by Sherpa climbers, and equipped with equipment calibrated by decades of industrial development. The wait at the Hillary Step — the technical crux of the standard route — can be measured in hours.\n\nThe commercialisation of Everest has been criticised extensively, and the criticisms are valid: it has led to overcrowding that creates its own dangers, generated enormous waste at altitude that is difficult to remove, and created a market dynamic in which operators compete for clients by reducing safety margins. It has also brought significant economic benefits to Sherpa communities and made possible a diversity of ascents that the elitism of traditional mountaineering would not have allowed.\n\nWhat it has definitively ended is the possibility of the summit as a measure of exceptional individual achievement. When the mountain is accessible to anyone with the money to pay for it and the physical condition to endure it, it is no longer an extreme environment but a managed experience.\n\n\"The mountain hasn't changed,\" says mountaineer Ed Viesturs. \"The experience of climbing it has.\"",
    category_index: 4,
    tag_indexes: [0, 13, 7],
    featured: false,
    published_at: 82.days.ago
  },
  {
    title: "The Grammar of Game Design",
    excerpt: "Video games have developed a vocabulary of meaning that their designers often cannot articulate. A critic tries to map it.",
    body: "The first time a player enters a new area in Dark Souls, they encounter a message on the ground, written by another player: \"Try jumping.\" It is, almost certainly, advice that will result in the player jumping off a ledge and dying. This is considered, within the game's community, hilarious.\n\nBut consider what the joke requires. It requires that the player understands that messages are written by other players, that some of those players are malicious, that jumping from height causes death, and that the humour of the situation depends on the gap between the advice's apparent helpfulness and its actual consequence. It requires, in other words, a sophisticated understanding of the game's mechanics, its social ecosystem, and its aesthetics of suffering.\n\nVideo games have developed a grammar — a system of conventions, expectations, and references that creates meaning through combination — that is as complex as the grammar of cinema or literature, and about which far less critical work has been done. The reasons for this are partly sociological (the people who study culture are not always the people who play games) and partly inherent to the form: games are interactive in ways that make the usual tools of criticism — close reading, textual analysis — difficult to apply.\n\n\"We have been making games for fifty years,\" says game designer Will Wright. \"We have been thinking about what they mean for about ten.\"",
    category_index: 0,
    tag_indexes: [17, 3, 2],
    featured: false,
    published_at: 83.days.ago
  },
  {
    title: "The Doctors Without Borders",
    excerpt: "Médecins Sans Frontières operates in active war zones, epidemic zones, and disaster sites. What it takes to do that work.",
    body: "The hospital in Bangui, capital of the Central African Republic, is run by Médecins Sans Frontières in a city that has been in varying states of civil conflict for more than a decade. The building — solid concrete, generator-powered, staffed by a combination of international volunteers and local employees — handles surgical cases, trauma, infectious disease, and maternal health for a population that has effectively no other option.\n\nMSF was founded in 1971 by a group of French physicians who had worked in Biafra and concluded that traditional humanitarian neutrality — the Red Cross model of silence in exchange for access — was morally untenable when confronted with atrocity. The organisation would provide medical care in conflict zones, and it would also bear witness to what it saw and report it publicly. The principle of témoignage — witnessing — has occasionally cost MSF access and has invariably created friction with the governments and militias on whose territory it operates.\n\nThe work requires a particular kind of person — or rather, it attracts people for whom the alternative is, in some sense, impossible to contemplate. MSF doctors do not earn large salaries, do not have comfortable postings, and do not return home intact.\n\n\"People ask me why I do this,\" says Dr. Amani Toure, who has worked with MSF in South Sudan, Libya, and Yemen. \"I find it hard to explain the question. This is what medicine is for.\"",
    category_index: 7,
    tag_indexes: [0, 13, 8],
    featured: true,
    published_at: 84.days.ago
  },
  {
    title: "How Countries Recover From Dictatorship",
    excerpt: "The transition from authoritarian rule to democracy is one of political science's central puzzles. The record is mixed.",
    body: "In 1989, the Berlin Wall fell. Between 1989 and 1991, approximately thirty countries transitioned from communist or authoritarian rule to some form of electoral democracy. The transition was the largest simultaneous democratic wave in history, and it produced radically different outcomes. Some countries — Poland, the Czech Republic, Estonia — became stable, prosperous liberal democracies. Others — Russia, Belarus, Hungary — transitioned to new forms of authoritarianism within a decade.\n\nThe political science of democratic transition has identified several factors that appear to matter. The strength of civil society institutions — trade unions, churches, professional associations, universities — that existed prior to the transition. The existence of a broad coalition behind the transition, rather than a narrow elite agreement. The economic conditions in the transition period. The legacy of previous democratic experience.\n\nBut the predictive power of these factors is limited. The Eastern European transitions of 1989 confounded most expert predictions. The Arab Spring of 2011 produced durable democracy only in Tunisia. South Africa's peaceful transition in 1994 succeeded despite predictions of catastrophic ethnic violence.\n\n\"Democratic transitions are not processes that can be engineered from outside,\" says political scientist Samuel Huntington. \"They are political events that happen when the conditions are right. The scholar's job is to understand why the conditions are sometimes right and sometimes not. We remain some distance from a satisfactory answer.\"",
    category_index: 2,
    tag_indexes: [17, 2, 9],
    featured: false,
    published_at: 85.days.ago
  },
  {
    title: "The Furniture Makers of Oaxaca",
    excerpt: "In the villages around the Mexican city, woodworking traditions that predate the Spanish conquest are thriving in new forms.",
    body: "The workshop of Ernesto Vargas is in a village called San Martín Tilcajete, twenty kilometres from Oaxaca city, and it is so full of colour that walking into it is a kind of optical event. Every surface — every table, every shelf, every carving in progress — is covered in the intricate geometric patterns of the alebrijes tradition, the painted wooden figures that have become one of the most recognised forms of Mexican folk art.\n\nVargas is the third generation of his family to carve alebrijes, and he has expanded the tradition beyond the small figures his grandfather made into furniture, architectural installations, and large-scale public sculpture. The patterns — derived from pre-Columbian geometric design, filtered through centuries of craft development — are applied by hand using brushes with single horsehairs, a process that requires weeks for a single piece.\n\nThe alebrijes tradition is, in one sense, a success story: it has maintained artistic vitality across generations, attracted significant collector and museum interest, and provided economic stability for the village communities that produce it. In another sense, it is under the same pressures as every traditional craft in the age of globalisation: cheap mass-produced imitations, competition from factory-made goods, and the difficulty of passing skills to a generation that has other options.\n\n\"The tradition is alive,\" says Vargas. \"But it requires care. Like any living thing.\"",
    category_index: 10,
    tag_indexes: [7, 4, 14],
    featured: false,
    published_at: 86.days.ago
  },
  {
    title: "The Long Game of Climate Policy",
    excerpt: "Decades of climate negotiations have produced agreements, commitments, and targets. The temperature keeps rising.",
    body: "The first World Climate Conference was held in Geneva in 1979. It produced a declaration calling for international cooperation on climate change. The second was held in 1990 and produced a framework for the negotiations that would eventually become the UN Framework Convention on Climate Change, signed in 1992. The Kyoto Protocol followed in 1997. The Copenhagen Accord in 2009. The Paris Agreement in 2015.\n\nIn the same period, global average temperatures rose by approximately 0.8 degrees Celsius above pre-industrial levels. CO2 concentrations in the atmosphere rose from 336 parts per million in 1979 to 421 parts per million in 2023. Annual global greenhouse gas emissions rose from approximately 30 billion tonnes to approximately 55 billion tonnes.\n\nThe gap between the diplomatic output and the physical reality is one of the defining features of the climate crisis. The politics have produced agreements; the agreements have produced commitments; the commitments have produced insufficient action. Each annual Conference of Parties produces a final communiqué that is, from the perspective of the physical climate, largely meaningless.\n\nThe reasons for this gap are structural and not unique to climate: the collective action problem, the time horizons of electoral politics, the power of incumbent industries, and the asymmetry between those who benefit from fossil fuels and those who bear the cost of their combustion.\n\n\"We have known what needs to happen for fifty years,\" says climate scientist James Hansen. \"The problem was never ignorance. It was interests.\"",
    category_index: 9,
    tag_indexes: [2, 10, 9],
    featured: false,
    published_at: 87.days.ago
  },
  {
    title: "The Readers Who Saved the Book",
    excerpt: "Book clubs have been unfashionable for most of literary history. They may now be the most important institution in publishing.",
    body: "Oprah Winfrey's Book Club, which launched in 1996, could move a novel from obscurity to bestseller status within a week. The effect — immediate, measurable, and reproducible — demonstrated something that publishers had suspected but never quantified: that reading is a social activity, that recommendations from trusted sources matter more than advertising, and that the book market, like most markets, is driven by a small number of influential intermediaries.\n\nOprah's club was the most visible version of a much broader phenomenon. Book clubs — reading groups, as they are more commonly called in the UK — have existed since the seventeenth century, but their penetration of the general reading public expanded dramatically in the 1990s and has continued to grow. Current estimates suggest that approximately five million people in the UK and fifteen million in the United States participate in some form of organised reading group.\n\nThe publishing industry's relationship with book clubs has evolved from suspicious condescension — serious literary fiction was considered above the book-club market — to enthusiastic cultivation. Publishers now produce reading group editions with discussion questions. Authors give book-club video calls. Literary prizes are partially calibrated to the tastes of reading group members.\n\n\"The book club reader is not a category of reader,\" says publisher Sarah Savitt. \"She is the reader. She is the person who makes publishing economically viable. She should have been taken seriously thirty years ago.\"",
    category_index: 12,
    tag_indexes: [11, 7, 2],
    featured: false,
    published_at: 88.days.ago
  },
  {
    title: "Running on Empty: The Ultra-Marathon of Modern Life",
    excerpt: "Burnout was classified as a medical condition in 2019. Why did it take so long, and what does its recognition change?",
    body: "The World Health Organization added burnout to its International Classification of Diseases in 2019, defining it as \"a syndrome conceptualized as resulting from chronic workplace stress that has not been successfully managed.\" The recognition was significant: for decades, burnout had been described as a lifestyle issue, a character failing, or simply the price of ambition. The ICD classification placed it in the medical register, giving it the status of a condition rather than a complaint.\n\nThe research on burnout had been accumulating for decades before the classification. Christina Maslach, the psychologist who developed the primary measurement tool for burnout in the 1970s, documented three components: exhaustion (the depletion of emotional and physical resources), depersonalisation (a growing distance and cynicism toward the people one serves), and reduced sense of personal accomplishment. The triad appears consistently across cultures, professions, and time periods.\n\nWhat changed in the period leading up to the ICD classification was the scale. Burnout rates in healthcare, teaching, law, and finance had been rising for a decade before 2019. The pandemic dramatically accelerated the process, particularly in healthcare, where surveys conducted in 2021 and 2022 found burnout rates of 60 to 70 percent among hospital staff in many countries.\n\n\"Burnout is what happens when the demand for care exceeds the capacity to provide it, indefinitely,\" says psychologist Emily Nagoski. \"It is not a personal failure. It is a system operating beyond its design limits.\"",
    category_index: 7,
    tag_indexes: [11, 2, 7],
    featured: false,
    published_at: 89.days.ago
  },
  {
    title: "The Art of Doing Nothing",
    excerpt: "In South Korea, idle hands are becoming a form of resistance. What the 'doing nothing' movement says about modern life.",
    body: "The Space Out Competition began in 2014 in Seoul. Participants are required to do nothing — no smartphones, no conversation, no reading — for ninety minutes. Heart rate is monitored; the person whose heart rate is most consistent and closest to resting is declared the winner. In 2024, approximately two thousand people entered.\n\nThe competition is a joke that is also not a joke. It reflects a genuine cultural reckoning with the costs of South Korea's notorious productivity culture — the country with the longest working hours in the OECD, the highest rates of academic pressure on children, and a suicide rate that consistently ranks among the highest in the developed world.\n\nThe hwadu — the Korean concept of \"doing nothing,\" drawn from Buddhist practice — has become a shorthand for a broader social conversation about the relationship between productivity and wellbeing. The bbali bbali (hurry hurry) culture that drove South Korea's economic miracle has produced a backlash: a growing movement, particularly among young Koreans, that celebrates slowness, aimlessness, and the deliberate rejection of optimisation.\n\nThe movement has its counterparts elsewhere — Italy's dolce far niente, the Danish concept of hygge — but in South Korea it carries a specifically political charge. It is not merely a preference for leisure. It is an argument that the society's priorities are wrong.\n\n\"Rest is not the absence of productivity,\" says philosopher Byung-Chul Han. \"It is the condition of all genuine thought.\"",
    category_index: 0,
    tag_indexes: [6, 2, 10],
    featured: false,
    published_at: 90.days.ago
  },
  {
    title: "The Future of the Museum",
    excerpt: "Institutions built for one era are being asked to serve another. What museums are becoming — and what they risk losing.",
    body: "The Louvre receives approximately 9 million visitors per year. A significant proportion of them come for a single purpose: to see the Mona Lisa. They stand in a crowd twenty people deep, raise their smartphones above their heads, take a photograph of a painting they can barely see, and leave. The time they spend in front of the painting averages six seconds.\n\nThis is not the museum experience the Louvre was designed for. The institution's founders envisioned a space for sustained contemplation, for the encounter with objects that reward close attention. The encounter that actually occurs — brief, mediated by a screen, shared with hundreds of strangers — is something different.\n\nMuseums are engaged in a deep conversation with themselves about what they are for and who they serve. The traditional answers — preservation, scholarship, education — remain valid but insufficient. The new answers being proposed — community engagement, accessibility, social justice, economic development — are sometimes in tension with the traditional ones.\n\nThe specific question of the Mona Lisa is, in one sense, trivial. In another sense, it is exemplary. The painting cannot be moved to a larger space without destroying the intimate galleries that make the rest of the Louvre what it is. It cannot be shown without the crowd. The crowd cannot be managed without the photograph. The photograph makes the visit meaningless in the original sense while giving it a different meaning.\n\n\"The museum's job is to create encounters between people and objects,\" says museum director Anne Baldassari. \"The encounter has changed. The job has not.\"",
    category_index: 10,
    tag_indexes: [7, 2, 6],
    featured: false,
    published_at: 91.days.ago
  },
  {
    title: "The Ethics of Space Tourism",
    excerpt: "Private companies are sending civilians into space. The environmental and ethical questions are only beginning to be asked.",
    body: "In July 2021, Jeff Bezos, the world's second-richest person, flew to the edge of space in a vehicle built by his company Blue Origin. The flight lasted eleven minutes. The carbon footprint, per passenger, was estimated at approximately 100 times that of a transatlantic flight. The press coverage was approximately one hundred times that of any IPCC report published in the same year.\n\nSpace tourism is in its infancy, and the numbers are small enough that its current environmental impact is negligible. Virgin Galactic, Blue Origin, and SpaceX have conducted dozens of civilian flights between them. The carbon cost is real but minor compared with the aviation industry's annual emissions.\n\nThe questions that matter are prospective. The industry's stated ambition is to make suborbital and eventually orbital flight accessible to many thousands of passengers per year. At that scale, the environmental calculations change significantly. High-altitude combustion products — black carbon, water vapour, and nitrogen oxides injected directly into the upper atmosphere — have impacts that ground-level emissions do not.\n\nThe deeper question is about priority. The resources — intellectual, financial, physical — being directed toward space tourism are not available for other uses. Whether those resources would produce more benefit deployed differently is a genuinely open question, and one that the industry has no particular interest in encouraging people to ask.\n\n\"Space is not the answer to any problem that exists on Earth,\" says astrophysicist Martin Rees. \"It is, at best, an addition to the problems.\"",
    category_index: 3,
    tag_indexes: [10, 2, 6],
    featured: false,
    published_at: 92.days.ago
  },
  {
    title: "The Growers Who Feed the World's Best Restaurants",
    excerpt: "Behind every celebrated chef is a network of small producers whose names appear only in thank-you notes.",
    body: "The tomatoes at the three-Michelin-starred restaurant in Copenhagen are grown on an island in the Øresund by a family who have been farming the same land for four generations. The chef visits twice a year. The grower visits the restaurant never — she doesn't like cities. But she and the chef talk weekly about variety selection, harvest timing, and flavour development, in conversations that are, from the outside, indistinguishable from conversations between colleagues of equal standing.\n\nThis relationship — intimate, reciprocal, sustained over years — is the model that the best restaurants in the world have adopted for their most important ingredients. The chef-farmer relationship has moved from transactional (the chef orders what the market supplies) to collaborative (the chef and farmer co-develop what the restaurant needs).\n\nThe shift has had effects that extend beyond flavour. It has created economic stability for small-scale producers who operate outside the commodity market, where margins are too thin to sustain quality. It has preserved varieties of fruit, vegetable, and grain that would otherwise have been displaced by higher-yielding, lower-quality alternatives. And it has changed the economics of fine dining in ways that are beginning to be visible in the prices.\n\n\"The ingredient is the cooking,\" says chef René Redzepi. \"Everything else is technique. Technique can be learned quickly. Growing a perfect ingredient takes a lifetime.\"",
    category_index: 5,
    tag_indexes: [0, 7, 14],
    featured: false,
    published_at: 93.days.ago
  },
  {
    title: "The Psychologists Who Study Evil",
    excerpt: "What does research on atrocity, obedience, and moral disengagement tell us about ordinary human capacity for harm?",
    body: "Philip Zimbardo's Stanford Prison Experiment of 1971 is one of the most famous — and most methodologically contested — studies in psychology. In the experiment, students randomly assigned to play \"guards\" in a simulated prison began, within days, treating students assigned to play \"prisoners\" with genuine cruelty. Zimbardo halted the experiment after six days, and concluded that the situation, not the disposition, was the primary driver of the behaviour.\n\nThe experiment has been substantially revised in subsequent scholarship. A 2018 investigation revealed that Zimbardo had coached the guard participants to be authoritarian, undermining his own conclusions about situational forces. The experiment's findings, always overstated, became even more difficult to sustain.\n\nBut the underlying question — under what conditions do ordinary people commit atrocities? — remains the most important question in moral psychology, and the research that has accumulated since Zimbardo is more rigorous and more disturbing than his conclusions.\n\nHannah Arendt's observation about the \"banality of evil\" — made about Adolf Eichmann's trial — has been partially vindicated and partially complicated by decades of research. Evil, the evidence suggests, is not banal: it requires active processes of moral disengagement, dehumanisation, and ideological justification. But neither is it the exclusive province of monsters. The conditions for its emergence are more common than we would like.\n\n\"Understanding how atrocity is possible is not the same as excusing it,\" says social psychologist James Waller. \"It is the prerequisite for preventing it.\"",
    category_index: 3,
    tag_indexes: [6, 2, 0],
    featured: false,
    published_at: 94.days.ago
  },
  {
    title: "The Architects of the Refugee Camp",
    excerpt: "More than 100 million people live in humanitarian settlements. What design can do — and what it cannot — for people in crisis.",
    body: "The Za'atari refugee camp in northern Jordan opened in 2012 to receive Syrians fleeing civil war. It was designed, by UNHCR standards, as a temporary facility for a few thousand people for a few months. By 2013, it held 150,000 people and was the fourth-largest city in Jordan. In 2024, it had a permanent population of approximately 80,000 people, a permanent marketplace, schools, hospitals, and what its residents call, with dark precision, their neighbourhood.\n\nThe architecture of humanitarian settlements has been transformed by this experience — the discovery that \"temporary\" means decades, that \"emergency\" means permanence, and that the solutions designed for brief crises are being asked to bear the weight of indefinite habitation.\n\nOrganisations like Architecture for Humanity and MASS Design Group have spent years developing approaches that treat refugees not as passive recipients of aid but as participants in the design of their own environments. Modular systems that can be configured differently as family compositions change. Materials that can be sourced and fabricated locally. Public spaces that support the social life that makes long-term settlement bearable.\n\nThe results are incremental and imperfect. The deeper problem — that the international system has failed to resolve the conflicts and inequalities that produce refugees — is not within architecture's power to address.\n\n\"Good design in a camp is better than bad design in a camp,\" says architect Cameron Sinclair. \"It is not a substitute for not having a camp at all.\"",
    category_index: 16,
    tag_indexes: [7, 0, 13],
    featured: false,
    published_at: 95.days.ago
  },
  {
    title: "Learning to Fail Well",
    excerpt: "Schools teach students to avoid mistakes. New research suggests the opposite approach produces better learning.",
    body: "The concept of desirable difficulty — the idea that learning is enhanced by conditions that make initial acquisition harder — has been accumulating evidence for three decades. Spaced practice is more effective than massed practice. Testing is more effective than re-reading. Interleaving different types of problems is more effective than blocking them. All of these findings violate the intuition that learning should feel smooth and successful.\n\nThe most counterintuitive finding, and the most difficult to implement, concerns failure. Research by Manu Kapur at ETH Zurich has shown consistently that students who are asked to attempt problems before being taught how to solve them — and who therefore produce incorrect or incomplete answers — learn the material more deeply than students who are taught the solution first and then practise it.\n\nThe mechanism appears to involve the construction of understanding through the experience of not-knowing. Students who fail first have a mental model of the problem — a scaffold, however broken — onto which the correct solution can be placed. Students who receive the solution first have to build the scaffold and place the solution simultaneously, which is more cognitively demanding and produces shallower encoding.\n\nThe implications for education are significant and largely unadopted. Schools are structured to minimise failure: tests are preceded by teaching, exercises follow instruction, marks reward correct answers. A system structured around productive failure would look very different — and would require persuading parents, students, and administrators that wrong answers on the way to right answers are not failures but features.\n\n\"The education system optimises for performance,\" says psychologist Robert Bjork. \"It should optimise for learning. These are not the same thing.\"",
    category_index: 18,
    tag_indexes: [2, 11, 7],
    featured: false,
    published_at: 96.days.ago
  },
  {
    title: "The Jazz Musician Who Changed America",
    excerpt: "Miles Davis reinvented his music every decade. What the arc of his career reveals about artistic evolution.",
    body: "Miles Davis was born in 1926 in Alton, Illinois, and died in 1991 in Santa Monica, California. In the intervening sixty-five years, he played bebop, cool jazz, hard bop, modal jazz, jazz fusion, and electro-funk, reinventing his sound so completely at each transition that critics who had praised his previous work often refused to accept the new direction.\n\nThe reinventions were not driven by market considerations — they often cost Davis commercial ground. They were driven by a restlessness that colleagues describe as almost pathological: an inability to be comfortable with what he had already achieved, a compulsion toward the next thing before the current thing was exhausted.\n\nKind of Blue, recorded in 1959, is the best-selling jazz album in history. Davis moved away from its modal sound within three years, toward the denser, more European-influenced work of the 1960s. Bitches Brew, recorded in 1969, created jazz fusion and alienated a generation of jazz purists. He then stopped recording for five years, returned with On the Corner, and continued inventing through the decade before his death.\n\nThe career is sometimes cited as an argument for artistic courage and against the comfort of success. It can equally be read as evidence of how completely great artists are in the grip of forces they cannot fully articulate.\n\n\"I don't know what will happen next,\" Davis said in an interview in 1985. \"I never have. That's why I keep playing.\"",
    category_index: 14,
    tag_indexes: [0, 8, 17],
    featured: true,
    published_at: 97.days.ago
  },
  {
    title: "The Complicated Legacy of Green Cities",
    excerpt: "Urban greening projects are transforming cities worldwide. Who benefits — and who gets displaced?",
    body: "The High Line, opened in 2009 on a disused elevated railway in Manhattan's meatpacking district, is one of the most celebrated urban design interventions of the century. It transformed a derelict structure into a linear park that attracts eight million visitors per year, catalysed more than $2 billion in private development, and became a model for similar projects in Chicago, Philadelphia, Atlanta, and dozens of cities around the world.\n\nIt also displaced low-income residents. Property values in the surrounding neighbourhood rose sharply after the High Line opened, making previously affordable housing unaffordable and pushing out the working-class and immigrant communities that had made the neighbourhood viable for decades. The people who were displaced are not visible in the park's visitor statistics, but they are visible in the demographic transformation of the neighbourhood's census data.\n\nThe High Line's story is not unique. Urban greening projects — parks, green corridors, urban forests, community gardens — consistently produce positive environmental and health outcomes for cities overall, and consistently produce displacement of low-income populations in the immediate vicinity. The phenomenon has been named \"green gentrification\" by researchers, and it has been documented in cities across North America, Europe, and Asia.\n\nThe policy challenge is to capture the benefits of urban greening while distributing them more equitably — which requires, at minimum, anti-displacement measures that are more robust than those currently applied in most cities.\n\n\"The park is good,\" says urban ecologist Isabelle Anguelovski. \"The question is good for whom.\"",
    category_index: 9,
    tag_indexes: [2, 10, 9],
    featured: false,
    published_at: 98.days.ago
  },
  {
    title: "The Surgeons Learning in a Simulation Lab",
    excerpt: "Medical training has always required practicing on real patients. Virtual reality and simulation are changing that — slowly.",
    body: "The first time a surgical resident makes an incision in a human abdomen, they have typically made the same incision in a pig, a cadaver, and a synthetic model dozens or hundreds of times. The progression — from simulation to corpse to living patient — is the established pedagogy of surgical training, and it has remained largely unchanged since William Halsted developed it at Johns Hopkins in the 1890s.\n\nWhat is changing is the fidelity and accessibility of the simulation layer. VR surgical training systems can now replicate the haptic resistance of tissue, the dynamics of bleeding, the behaviour of organs under retraction, with enough accuracy that performance in the simulation predicts performance in the operating room. Studies show that residents trained with high-fidelity simulation reach proficiency faster and make fewer errors in their first independent procedures.\n\nThe implications extend beyond training. In a world where simulation can substitute for practice on patients, the justification for \"learning curves\" — the period during which a surgeon is developing skills at the patient's expense — becomes less defensible. Patients have a legitimate interest in operating-room procedures performed by experienced surgeons, and simulation can bring the threshold of experience earlier in a career.\n\nThe barriers to adoption are primarily economic and cultural. High-fidelity simulators are expensive. Surgical training programs are conservative. And the culture of surgical education — in which learning by doing, even when doing means making mistakes on patients, has been the norm for a century — changes slowly.\n\n\"We can do better,\" says simulation researcher Roger Kneebone. \"The technology exists. The question is whether the will does.\"",
    category_index: 7,
    tag_indexes: [1, 2, 11],
    featured: false,
    published_at: 99.days.ago
  }
]

additional_created = 0
additional_articles_data.each do |data|
  next if Article.exists?(title: data[:title])

  article = Article.create!(
    title:        data[:title],
    excerpt:      data[:excerpt],
    body:         data[:body],
    featured:     data[:featured],
    published_at: data[:published_at]
  )

  article.categories = [categories[data[:category_index]]]
  article.tags = data[:tag_indexes].map { |i| tags[i] }
  additional_created += 1
end

puts "Additional articles created: #{additional_created} (#{Article.count} total)"

# ── Attach images to articles ─────────────────────────────────────────────────
require "open-uri"

# Curated Unsplash image IDs by category theme
image_sources = {
  # Culture / City
  0  => %w[photo-1477959858617-67f85cf4f1df photo-1480714378408-67cf0d13bc1b photo-1449824913935-59a10b8d2000],
  # Technology
  1  => %w[photo-1518770660439-4636190af475 photo-1461749280684-dccba630e2f6 photo-1555949963-ff9fe0c870eb],
  # Politics
  2  => %w[photo-1529107386315-e1a2ed48a620 photo-1568455810521-7c0f2c1edf5c photo-1507003211169-0a1dd7228f2d],
  # Science
  3  => %w[photo-1507413245164-6160d8298b31 photo-1532187863486-abf9dbad1b69 photo-1530026405959-5d4dd596a3e6],
  # Travel
  4  => %w[photo-1488085061387-422e29b40080 photo-1501555088652-021faa106b9b photo-1476514525535-07fb3b4ae5f1],
  # Food & Drink
  5  => %w[photo-1504674900247-0877df9cc836 photo-1493770348161-369560ae357d photo-1414235077428-338989a2e8c0],
  # Fashion
  6  => %w[photo-1490481651871-ab68de25d43d photo-1558769132-cb1aea458c5e photo-1483985988355-763728e1935b],
  # Health & Wellness
  7  => %w[photo-1571019613454-1cb2f99b2d8b photo-1506126613408-eca07ce68773 photo-1544367567-0f2fcb009e0b],
  # Business
  8  => %w[photo-1507679799987-c73779587ccf photo-1521791136064-7986c2920216 photo-1454165804606-c3d57bc86b40],
  # Environment
  9  => %w[photo-1497436072909-60f360fe1ce9 photo-1448375240586-882707db888b photo-1542601906990-b4d3fb778b09],
  # Arts
  10 => %w[photo-1541961017774-22349e4a1262 photo-1513364776144-60967b0f800f photo-1460661419201-fd4cecdf8a8b],
  # Sports
  11 => %w[photo-1461896836934-ffe607ba8211 photo-1517649763962-0c623066013b photo-1579952363873-27f3bade9f55],
  # Literature
  12 => %w[photo-1512820790803-83ca734da794 photo-1457369804613-52c61a468e7d photo-1481627834876-b7833e8f5570],
  # Film & TV
  13 => %w[photo-1536440136628-849c177e76a1 photo-1524985069026-dd778a71c7b4 photo-1440404653325-ab127d49abc1],
  # Music
  14 => %w[photo-1511379938547-c1f69419868d photo-1493225457124-a3eb161ffa5f photo-1514320291840-2e0a9bf2a9ae],
  # Photography
  15 => %w[photo-1452780212461-69d1b41a4a6e photo-1516035069371-29a1b244cc32 photo-1542038784456-1ea8e935640e],
  # Architecture
  16 => %w[photo-1486325212027-8081e485255e photo-1487958449943-2429e8be8625 photo-1518005068251-37900150dfca],
  # History
  17 => %w[photo-1461360370896-922624d12aa1 photo-1507003211169-0a1dd7228f2d photo-1572116469696-31de0f17cc34],
  # Education
  18 => %w[photo-1523050854058-8df90110c9f1 photo-1509062522246-3755977927d7 photo-1524178232363-1fb2b075b655],
  # Opinion
  19 => %w[photo-1478358161113-b0e11994a36b photo-1504711434969-e33886168f5c photo-1499244571948-7ccddb3da7d8]
}

puts "Attaching images to articles..."
attached_count = 0

Article.find_each do |article|
  next if article.images.attached?

  category_idx = categories.index(article.categories.first) || 0
  image_ids = image_sources[category_idx] || image_sources[0]
  image_id = image_ids[article.id % image_ids.length]
  url = "https://images.unsplash.com/#{image_id}?w=800&q=80"

  begin
    downloaded = URI.open(url, "User-Agent" => "Mozilla/5.0 (seed script)", read_timeout: 15)
    article.images.attach(
      io:           downloaded,
      filename:     "article-#{article.id}.jpg",
      content_type: "image/jpeg"
    )
    attached_count += 1
    print "."
  rescue => e
    print "x"
  end
end

puts ""
puts "Images attached: #{attached_count} / #{Article.count} articles"

# ── Team Members ──────────────────────────────────────────────────────────────
team_members_data = [
  {
    name: "Niti Khatiwada",
    role: "Editor in Chief",
    slug: "niti-khatiwada",
    bio: "Co-founder and Editor in Chief at Danphe Software Labs. Award-winning journalist with 20 years of experience in long-form narrative writing and investigative reporting.",
    avatar_img: 5
  },
  {
    name: "Saroj Khatiwada",
    role: "Deputy Editor",
    bio: "Deputy Editor at Danphe Software Labs. Former foreign correspondent covering politics and conflict across South Asia. Now overseeing investigative and science coverage.",
    avatar_img: 12
  },
  {
    name: "Yana Rai",
    role: "Arts & Culture Editor",
    bio: "Arts & Culture Editor at Danphe Software Labs. Critic and essayist whose work spans film, architecture, and contemporary art.",
    avatar_img: 9
  },
  {
    name: "Sanjay Karki",
    role: "Digital Editor",
    bio: "Digital Editor at Danphe Software Labs. Leads online presence and audience development. Specialist in data journalism and newsletter publishing.",
    avatar_img: 33
  },
  {
    name: "Sanzay Manandhar",
    role: "Senior Writer",
    bio: "Senior Writer at Danphe Software Labs. Long-form narrative journalist specialising in human interest stories and social issues.",
    avatar_img: 15
  },
  {
    name: "Raghav Thapa",
    role: "Science & Technology Editor",
    bio: "Science & Technology Editor at Danphe Software Labs. Former researcher turned journalist covering emerging technology, climate science, and health policy.",
    avatar_img: 68
  },
  {
    name: "Saja Shakya",
    role: "Investigative Reporter",
    bio: "Investigative Reporter at Danphe Software Labs. Specialises in accountability journalism, following the money in politics and public institutions.",
    avatar_img: 47
  },
  {
    name: "Ravi Bhusal",
    role: "Photo Editor",
    bio: "Photo Editor at Danphe Software Labs. Documentary photographer and visual storyteller who brings depth and humanity to every piece we publish.",
    avatar_img: 52
  },
  {
    name: "Nitesh Khatiwada",
    role: "IT Specialist",
    bio: "IT Specialist at Danphe Software Labs. Manages digital infrastructure, security, and technical operations across all platforms.",
    avatar_img: 64
  }
]

puts "Creating team members..."
team_members = []

team_members_data.each do |data|
  member = TeamMember.find_or_initialize_by(name: data[:name])
  member.role = data[:role]
  member.bio  = data[:bio]
  member.slug = data[:slug] if data[:slug].present?
  member.save!

  unless member.avatar.attached?
    url = "https://i.pravatar.cc/300?img=#{data[:avatar_img]}"
    begin
      downloaded = URI.open(url, "User-Agent" => "Mozilla/5.0 (seed script)", read_timeout: 15)
      member.avatar.attach(
        io:           downloaded,
        filename:     "#{member.slug}.jpg",
        content_type: "image/jpeg"
      )
      print "."
    rescue => e
      print "x"
    end
  else
    print "-"
  end

  team_members << member
end

puts ""
puts "Team members: #{TeamMember.count} total"

# ── Assign articles to team members ───────────────────────────────────────────
articles_without_author = Article.where(team_member_id: nil).to_a
articles_without_author.each_with_index do |article, i|
  article.update_columns(team_member_id: team_members[i % team_members.length].id)
end

puts "Articles assigned to authors: #{Article.where.not(team_member_id: nil).count} / #{Article.count}"
