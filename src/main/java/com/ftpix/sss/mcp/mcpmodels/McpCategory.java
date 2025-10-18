package com.ftpix.sss.mcp.mcpmodels;

import com.ftpix.sss.models.Category;
import com.ftpix.sss.models.NewCategoryIcon;

public record McpCategory(String name, String categoryGroup, String[] searchTerms) {
}

