package com.ftpix.sss.models;


/**
 * CSS class for icons is cat-&lt;enum name&gt;
 */
public enum NewCategoryIcon {

    food(Constants.SHOPPING, new String[]{"food", "eat", "restaurant"}),
    gas(Constants.TRANSPORTS, new String[]{"petrol", "gas", "diesel"}),
    ;

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
    }
}
