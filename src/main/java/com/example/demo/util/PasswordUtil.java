package com.example.demo.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

	public static String hashPassword(String rawPassword) {
		if (rawPassword == null) {
			return null;
		}
		return BCrypt.hashpw(rawPassword, BCrypt.gensalt(10));
	}

	public static boolean isHashed(String password) {
		return password != null
				&& (password.startsWith("$2a$") || password.startsWith("$2b$") || password.startsWith("$2y$"));
	}

	public static boolean checkPassword(String rawPassword, String storedPassword) {
		if (rawPassword == null || storedPassword == null) {
			return false;
		}
		if (isHashed(storedPassword)) {
			return BCrypt.checkpw(rawPassword, storedPassword);
		}
		// Hỗ trợ các tài khoản mẫu cũ lưu plain-text trong DB
		return rawPassword.equals(storedPassword);
	}
}
