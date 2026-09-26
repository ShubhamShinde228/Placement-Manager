import java.sql.Connection;
import java.sql.Statement;
import com.placement.util.DBConnection;

public class ModuleSchemaUpdate {
    public static void main(String[] args) {
        String sql = "CREATE TABLE IF NOT EXISTS notifications (" +
                     "id INT AUTO_INCREMENT PRIMARY KEY, " +
                     "message VARCHAR(255) NOT NULL, " +
                     "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                     "is_read BOOLEAN DEFAULT FALSE" +
                     ")";
        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement()) {
            stmt.execute(sql);
            System.out.println("Notifications table created successfully!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
