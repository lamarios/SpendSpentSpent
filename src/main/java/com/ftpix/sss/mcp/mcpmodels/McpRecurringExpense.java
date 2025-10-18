package com.ftpix.sss.mcp.mcpmodels;

public record McpRecurringExpense(String category, double amount, String note, String lastOccurrence, String nextOccurrence) {

}
