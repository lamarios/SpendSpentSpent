package com.ftpix.sss.models;


/**
 * CSS class for icons is cat-&lt;enum name&gt;
 */
public enum NewCategoryIcon {

    food(Constants.SHOPPING, new String[]{"food", "eat", "restaurant"}),
    gas(Constants.TRANSPORTS, new String[]{"petrol", "gas", "diesel"}),
    amazon(Constants.BRANDS, new String[]{"amazon", "prime", "aws", "amazon web services", "streaming"}),
    apple(Constants.BRANDS, new String[]{"apple", "icloud", "iphone", "ipad", "mac", "ipod", "streaming", "apple music"}),
    netflix(Constants.BRANDS, new String[]{"netflix", "streaming"}),
    google(Constants.BRANDS, new String[]{"google", "suite", "youtube", "gmail"}),
    youtube(Constants.BRANDS, new String[]{"youtube", "streaming"}),
    books(Constants.HOBBIES, new String[]{"book", "books", "reading", "read", "litterature", "magazines"}),
    camera(Constants.HOBBIES, new String[]{"photo", "photography", "lens", "video", "camera", "recording"}),
    eyecare(Constants.HEALTH, new String[]{"glasses", "eye care", "optician", "spectacles"}),
    healthcare(Constants.HEALTH, new String[]{"doctor", "hospital", "health", "health care"}),
    medicine(Constants.HEALTH, new String[]{"medicine", "pills", "prescription"});

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
    }
}
