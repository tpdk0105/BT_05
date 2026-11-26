package com.example.demo.service;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.example.demo.entity.User;

public interface IUserService {

	User login(String username, String password);

	User register(String username, String password, String email, String fullname, String phone);

	Optional<User> findByUsername(String username);

	Optional<User> findByEmail(String email);

	boolean existsByUsername(String username);

	boolean existsByEmail(String email);

	List<User> findAll();

	Page<User> findAll(Pageable pageable);

	Page<User> search(String keyword, Pageable pageable);

	Optional<User> findById(Integer id);

	User save(User user);

	void deleteById(Integer id);

	long count();
}
