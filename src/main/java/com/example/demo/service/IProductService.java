package com.example.demo.service;

import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.example.demo.entity.Product;

public interface IProductService {

	/** Tìm kiếm cho Manager (keyword và categoryId đều có thể null). */
	Page<Product> search(String keyword, Integer categoryId, Pageable pageable);

	/** Hiển thị cho trang chủ: chỉ sản phẩm đang hoạt động, có thể lọc theo category. */
	Page<Product> findActive(Integer categoryId, Pageable pageable);

	Optional<Product> findById(Integer id);

	Product save(Product product);

	void deleteById(Integer id);

	long count();
}
