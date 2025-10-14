package com.ftpix.sss.mcp;

import com.ftpix.sss.models.Category;
import com.ftpix.sss.services.CategoryService;
import com.ftpix.sss.services.UserService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

@Service
public class MCPTools {

    private final CategoryService categoryService;
    private final UserService userService;

    @Autowired
    public MCPTools(CategoryService categoryService, UserService userService) {
        this.categoryService = categoryService;
        this.userService = userService;
    }

    public String getCurrentMcpUser() {
        ServletRequestAttributes attrs = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attrs == null) return "anonymous";
        HttpServletRequest req = attrs.getRequest();
        return (String) req.getAttribute("mcpUserId");
    }

    @Tool(name = "get_categories", description = "Get all user's expense categories")
    List<Category> getCategories() throws SQLException {
        List<Category> all = categoryService.getAll(userService.getById(UUID.fromString(getCurrentMcpUser())));
        return all;
    }
}
