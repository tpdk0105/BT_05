package com.example.demo.service.impl;

import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.example.demo.entity.Product;
import com.example.demo.repository.ProductRepository;
import com.example.demo.service.IProductService;

@Service
public class ProductServiceImpl implements IProductService {

	private final ProductRepository repo;

	public ProductServiceImpl(ProductRepository repo) {
		this.repo = repo;
	}

	@Override
	public Page<Product> search(String keyword, Integer categoryId, Pageable pageable) {
		boolean hasKey = StringUtils.hasText(keyword);
		if (hasKey && categoryId != null) {
			return repo.findByNameContainingAndCategoryId(keyword, categoryId, pageable);
		} else if (hasKey) {
			return repo.findByNameContaining(keyword, pageable);
		} else if (categoryId != null) {
			return repo.findByCategoryId(categoryId, pageable);
		}
		return repo.findAll(pageable);
	}

	@Override
	public Page<Product> findActive(Integer categoryId, Pageable pageable) {
		if (categoryId != null) {
			return repo.findByCategoryIdAndStatus(categoryId, 1, pageable);
		}
		return repo.findByStatus(1, pageable);
	}

	@Override
	public Optional<Product> findById(Integer id) {
		return repo.findById(id);
	}

	@Override
	public Product save(Product product) {
		return repo.save(product);
	}

	@Override
	public void deleteById(Integer id) {
		repo.deleteById(id);
	}

	@Override
	public long count() {
		return repo.count();
	}
}
