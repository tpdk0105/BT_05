package com.example.demo.service.impl;

import java.sql.Date;
import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.example.demo.entity.User;
import com.example.demo.repository.UserRepository;
import com.example.demo.service.IUserService;
import com.example.demo.util.PasswordUtil;

@Service
public class UserServiceImpl implements IUserService {

	private final UserRepository userRepository;

	public UserServiceImpl(UserRepository userRepository) {
		this.userRepository = userRepository;
	}

	@Override
	public User login(String username, String password) {
		Optional<User> opt = userRepository.findByUsername(username);
		if (opt.isPresent()) {
			User user = opt.get();
			if (PasswordUtil.checkPassword(password, user.getPassword())) {
				return user;
			}
		}
		return null;
	}

	@Override
	public User register(String username, String password, String email, String fullname, String phone) {
		User user = new User();
		user.setUsername(username);
		user.setPassword(PasswordUtil.hashPassword(password));
		user.setEmail(email);
		user.setFullname(fullname);
		user.setPhone(phone);
		user.setRoleid(3); // Default role: User
		user.setStatus(1); // Active immediately
		user.setCreatedDate(new Date(System.currentTimeMillis()));
		return userRepository.save(user);
	}

	@Override
	public Optional<User> findByUsername(String username) {
		return userRepository.findByUsername(username);
	}

	@Override
	public Optional<User> findByEmail(String email) {
		return userRepository.findByEmail(email);
	}

	@Override
	public boolean existsByUsername(String username) {
		return userRepository.existsByUsername(username);
	}

	@Override
	public boolean existsByEmail(String email) {
		return userRepository.existsByEmail(email);
	}

	@Override
	public List<User> findAll() {
		return userRepository.findAll();
	}

	@Override
	public Page<User> findAll(Pageable pageable) {
		return userRepository.findAll(pageable);
	}

	@Override
	public Page<User> search(String keyword, Pageable pageable) {
		return userRepository.findByUsernameContainingOrFullnameContainingOrEmailContaining(
				keyword, keyword, keyword, pageable);
	}

	@Override
	public Optional<User> findById(Integer id) {
		return userRepository.findById(id);
	}

	@Override
	public User save(User user) {
		return userRepository.save(user);
	}

	@Override
	public void deleteById(Integer id) {
		userRepository.deleteById(id);
	}

	@Override
	public long count() {
		return userRepository.count();
	}
}
