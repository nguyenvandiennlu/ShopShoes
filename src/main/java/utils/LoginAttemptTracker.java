package utils;

import jakarta.servlet.http.HttpSession;


public class LoginAttemptTracker {
    private static final String FAIL_COUNT_KEY = "loginFailCount";
    private static final String FIRST_FAIL_TIME_KEY = "loginFirstFailTime";
    private static final int MAX_ATTEMPTS = 3;
    private static final long LOCKOUT_DURATION_MS = 15 * 60 * 1000; // 15 phút
    private LoginAttemptTracker() {
    }
    public static boolean isRecaptchaRequired(HttpSession session) {
        if (session == null) return false;
        Integer failCount = (Integer) session.getAttribute(FAIL_COUNT_KEY);
        Long firstFailTime = (Long) session.getAttribute(FIRST_FAIL_TIME_KEY);
        if (failCount == null || firstFailTime == null) {
            return false;
        }

        if (System.currentTimeMillis() - firstFailTime > LOCKOUT_DURATION_MS) {
            resetAttempts(session);
            return false;
        }
        return failCount >= MAX_ATTEMPTS;
    }

    public static void recordFailedAttempt(HttpSession session) {
        if (session == null) return;
        
        Integer failCount = (Integer) session.getAttribute(FAIL_COUNT_KEY);
        Long firstFailTime = (Long) session.getAttribute(FIRST_FAIL_TIME_KEY);
        long now = System.currentTimeMillis();
        if (firstFailTime != null && (now - firstFailTime > LOCKOUT_DURATION_MS)) {
            failCount = 0;
            firstFailTime = null;
        }
        if (failCount == null || firstFailTime == null) {
            session.setAttribute(FAIL_COUNT_KEY, 1);
            session.setAttribute(FIRST_FAIL_TIME_KEY, now);
        } else {
            session.setAttribute(FAIL_COUNT_KEY, failCount + 1);
        }
    }
    public static void resetAttempts(HttpSession session) {
        if (session == null) return;
        session.removeAttribute(FAIL_COUNT_KEY);
        session.removeAttribute(FIRST_FAIL_TIME_KEY);
    }


    public static int getFailCount(HttpSession session) {
        if (session == null) return 0;
        Integer failCount = (Integer) session.getAttribute(FAIL_COUNT_KEY);
        return failCount != null ? failCount : 0;
    }
}
