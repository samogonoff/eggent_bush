# MS SQL Tool

Execute MS SQL Server queries and return results as a pandas DataFrame.

## When to Use

- Query MS SQL Server databases for data analysis
- Perform CRUD operations (SELECT, INSERT, UPDATE, DELETE)
- Analyze SQL query results with pandas
- Export query results to CSV files

## Connection String Format

Use ODBC driver connection string:

```
Driver={ODBC Driver 18 for SQL Server};Server=hostname;Database=dbname;UID=username;PWD=password;TrustServerCertificate=yes;
```

Or for Windows Authentication:
```
Driver={ODBC Driver 18 for SQL Server};Server=hostname;Database=dbname;Trusted_Connection=yes;
```

## Parameters

- `connection_string` - ODBC connection string for MS SQL Server
- `query` - SQL query to execute
- `params` - Optional query parameters for parameterized queries
- `save_to` - Optional file path to save results as CSV
- `preview_only` - If true, only analyze query without executing (returns preview + warnings)
- `confirm` - Must be `true` to execute INSERT/UPDATE/DELETE queries

## Output Format

The tool returns:
- Number of rows and columns
- Column names
- DataFrame head (first 10 rows)
- DataFrame data types
- Statistical summary (describe)

## Query Analysis & Safety

### Automatic Analysis

Before execution, the tool analyzes queries and detects dangerous operations:
- `INSERT`, `UPDATE`, `DELETE`, `DROP`, `TRUNCATE`, `ALTER`, `CREATE`, `MERGE`
- Returns preview with warnings about detected operations

### Safety Modes

1. **Preview Mode** (`preview_only: true`)
   - Analyzes query WITHOUT executing
   - Shows query preview + dangerous operations detected
   - Example:
   ```json
   { "connection_string": "...", "query": "SELECT * FROM users", "preview_only": true }
   ```

2. **Safe Mode** (default, for SELECT)
   - SELECT queries execute normally
   - No confirmation required for read-only operations

3. **Dangerous Mode** (for INSERT/UPDATE/DELETE)
   - Requires `confirm: true` to execute
   - Returns error without confirmation
   - Example:
   ```json
   { 
     "connection_string": "...", 
     "query": "DELETE FROM users WHERE id=1", 
     "confirm": true 
   }
   ```

## Guidelines

1. Always use parameterized queries when passing user input to prevent SQL injection
2. For large result sets, use `save_to` to export to CSV
3. The tool auto-installs pyodbc if not present
4. Results are returned as DataFrame for easy analysis in subsequent Python code
5. Use `preview_only: true` for unfamiliar queries to analyze before execution
6. Use `confirm: true` only when you intentionally want to modify data
