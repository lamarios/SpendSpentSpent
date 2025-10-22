package com.ftpix.sss.models;


/**
 * CSS class for icons is cat-&lt;enum name&gt;
 */
public enum NewCategoryIcon {

    food(Constants.SHOPPING, new String[]{"food", "eat", "restaurant"}),
    gas(Constants.TRANSPORTS, new String[]{"petrol", "gas", "diesel"}),
    amazon(Constants.BRANDS, new String[]{"amazon", "prime", "aws", "amazon web services", "streaming"}),
    apple(Constants.BRANDS, new String[]{"apple", "icloud", "iphone", "ipad", "mac", "ipod", "streaming", "apple music"}),
    netflix(Constants.BRANDS, new String[]{"netflix", "streaming", "tv", "movie"}),
    google(Constants.BRANDS, new String[]{"google", "suite", "youtube", "gmail"}),
    youtube(Constants.BRANDS, new String[]{"youtube", "streaming"}),
    books(Constants.HOBBIES, new String[]{"book", "books", "reading", "read", "literature", "magazines"}),
    camera(Constants.HOBBIES, new String[]{"photo", "photography", "lens", "video", "camera", "recording"}),
    eyecare(Constants.HEALTH, new String[]{"glasses", "eye care", "optician", "spectacles"}),
    healthcare(Constants.HEALTH, new String[]{"doctor", "hospital", "health", "health care"}),
    medicine(Constants.HEALTH, new String[]{"medicine", "pills", "prescription"}),
    hulu(Constants.BRANDS, new String[]{"hulu", "streaming", "tv", "movie"}),
    microsoft(Constants.BRANDS, new String[]{"microsoft", "windows", "one drive", "office", "365", "azure"}),
    playstation(Constants.BRANDS, new String[]{"sony", "playstation", "ps", "game", "gaming"}),
    school(Constants.EDUCATION, new String[]{"school", "education", "graduation", "college", "primary", "secondary", "degree"}),
    spotify(Constants.BRANDS, new String[]{"spotify", "streaming", "music", "podcast"}),
    xbox(Constants.BRANDS, new String[]{"xbox", "game pass", "game", "gaming"}),
    apartment(Constants.HOUSING, new String[]{"apartment", "home", "rent", "loan", "house", "condo", "condominium", "flat"}),
    electricity(Constants.HOUSING, new String[]{"electricity", "bills", "energy", "light", "lighting"}),
    furniture(Constants.HOUSING, new String[]{"furniture", "deco", "decoration"}),
    heater(Constants.HOUSING, new String[]{"heater", "bills", "energy", "heat"}),
    movies(Constants.HOBBIES, new String[]{"movies", "entertainment", "series", "tv", "television", "telly"}),
    music(Constants.HOBBIES, new String[]{"music", "streaming", "spotify", "deezer"}),
    music_equipment(Constants.HOBBIES, new String[]{"music", "guitar", "instrument", "piano"}),
    sport_equipment(Constants.HOBBIES, new String[]{"sport", "balls", "equipment"}),
    cloth(Constants.SHOPPING, new String[]{"cloth", "shop", "shopping"}),
    cloud(Constants.TECH, new String[]{"cloud", "storage", "icloud", "drive", "dropbox", "onedrive", "one drive", "goolge drive"}),
    credit_card(Constants.SHOPPING, new String[]{"credit card", "credit", "card", "shopping", "bill", "bank", "loan"}),
    gift(Constants.SHOPPING, new String[]{"gift", "birthday", "celebration", "shopping"}),
    groceries_bag(Constants.SHOPPING, new String[]{"groceries", "shopping", "supermarket", "market"}),
    haircut(Constants.SHOPPING, new String[]{"haircut", "cut", "hair", "hair do"}),
    handbag(Constants.SHOPPING, new String[]{"handbag", "shopping"}),
    house(Constants.HOUSING, new String[]{"home", "house", "rent", "loan"}),
    restaurant(Constants.HOUSING, new String[]{"restaurant", "food", "eat", "fast food"}),
    shopping_cart(Constants.SHOPPING, new String[]{"shopping", "groceries", "market", "supermarket"}),
    water(Constants.HOUSING, new String[]{"bill", "water"}),
    bus(Constants.TRANSPORTS, new String[]{"bus", "travel", "transport", "public"}),
    car(Constants.TRANSPORTS, new String[]{"car", "travel", "service", "fix", "repair", "maintenance"}),
    carengine(Constants.TRANSPORTS, new String[]{"car", "repair", "engine", "maintenance"}),
    computer(Constants.TECH, new String[]{"computer", "cpu", "ram","gpu", "fix", "gaming", "graphics card"}),
    documents(Constants.DOCUMENTS, new String[]{"official", "document", "documents", "certificate", "certification"}),
    games(Constants.TECH, new String[]{"gaming", "console", "controller", "pad", "xbox", "playstation", "switch", "video games", "steam"}),
    internet(Constants.TECH, new String[]{"internet", "broadband", "wifi", "connection", "3g", "lte", "4g"}),
    motorbike(Constants.TRANSPORTS, new String[]{"bike", "motorbike", "moto"}),
    phone(Constants.TECH, new String[]{"phone", "smartphone", "iphone", "android", "bill"}),
    plane(Constants.TRANSPORTS, new String[]{"plane", "travel", "flight"}),
    toll(Constants.TRANSPORTS, new String[]{"toll", "highway", "road"}),
    train(Constants.TRANSPORTS, new String[]{"train", "travel", "ticket"}),
    travel(Constants.TRANSPORTS, new String[]{"travel", "holidays"});

    private final String category;
    private final String[] searchTerms;

    NewCategoryIcon(String category, String[] searchTerms) {
        this.category = category;
        this.searchTerms = searchTerms;
    }

    public String getCategory() {
        return category;
    }

    public String[] getSearchTerms() {
        return searchTerms;
    }

    private static class Constants {
        public static final String SHOPPING = "shopping";
        public static final String TRANSPORTS = "transports";
        public static final String BRANDS = "brands";
        public static final String HOBBIES = "hobbies";
        public static final String HEALTH = "health";
        public static final String EDUCATION = "education";
        public static final String HOUSING = "housing";
        public static final String TECH = "tech";
        public static final String DOCUMENTS = "documents";
    }
}
