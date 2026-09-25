import org.mindrot.jbcrypt.BCrypt;
public class HashGen {
    public static void main(String[] args) {
        System.out.println("Admin@1234: " + BCrypt.hashpw("Admin@1234", BCrypt.gensalt(12)));
        System.out.println("Employer@123: " + BCrypt.hashpw("Employer@123", BCrypt.gensalt(12)));
        System.out.println("Seeker@123: " + BCrypt.hashpw("Seeker@123", BCrypt.gensalt(12)));
    }
}
