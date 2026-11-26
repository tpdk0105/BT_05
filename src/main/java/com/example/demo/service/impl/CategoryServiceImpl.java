package com.example.demo.service.impl;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.example.demo.entity.Category;
import com.example.demo.repository.CategoryRepository;
import com.example.demo.service.ICategoryService;

@Service
public class CategoryServiceImpl implements ICategoryService {

	private final CategoryRepository categoryRepository;

	public CategoryServiceImpl(CategoryRepository categoryRepository) {
		this.categoryRepository = categoryRepository;
	}

	@Override
	public List<Category> findAll() {
		return categoryRepository.findAll();
	}

	@Override
	public Page<Category> findAll(Pageable pageable) {
		return categoryRepository.findAll(pageable);
	}

	@Override
	public Page<Category> findByNameContaining(String keyword, Pageable page) {
		return categoryRepository.findByNameContaining(keyword, page);
	}

	@Override
	public Optional<Category> findById(Integer id) {
		return categoryRepository.findById(id);
	}

	@Override
	public Optional<Category> findByName(String name) {
		return categoryRepository.findByName(name);
	}

	@Override
	public Category save(Category category) {
		return categoryRepository.save(category);
	}

	@Override
	public void deleteById(Integer id) {
		categoryRepository.deleteById(id);
	}

	@Override
	public long count() {
		return categoryRepository.count();
	}
}
