import org.mindrot.jbcrypt.BCrypt;
public class TestHash {
    public static void main(String[] args) {
        String hash = "$2a$12$LJ3m4ys3F5L6g0v7B8rHKeDkR.Hy7bFHJV0CtH1Yq/Jq3R5dO6Bia";
        System.out.println("Admin@1234: " + BCrypt.checkpw("Admin@1234", hash));
        System.out.println("Admin@123: " + BCrypt.checkpw("Admin@123", hash));
        System.out.println("Employer@123: " + BCrypt.checkpw("Employer@123", hash));
        System.out.println("Candidate@123: " + BCrypt.checkpw("Candidate@123", hash));
        System.out.println("Seeker@123: " + BCrypt.checkpw("Seeker@123", hash));
        System.out.println("password: " + BCrypt.checkpw("password", hash));
        System.out.println("123456: " + BCrypt.checkpw("123456", hash));
    }
}
