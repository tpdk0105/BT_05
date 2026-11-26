package com.example.demo.service;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.example.demo.entity.Category;

public interface ICategoryService {

	List<Category> findAll();

	Page<Category> findAll(Pageable pageable);

	Page<Category> findByNameContaining(String keyword, Pageable page);

	Optional<Category> findById(Integer id);

	Optional<Category> findByName(String name);

	Category save(Category category);

	void deleteById(Integer id);

	long count();
}
