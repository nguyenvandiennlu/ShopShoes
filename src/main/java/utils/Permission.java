package utils;

public class Permission {
    public static final int VIEW = 1;
    public static final int ADD = 2;
    public static final int EDIT = 4;
    public static final int DELETE = 8;

    public static boolean check(int userMask, int requiredAction) {
        return (userMask & requiredAction) == requiredAction;
    }
}
