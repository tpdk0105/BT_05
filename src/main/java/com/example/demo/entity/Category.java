package com.example.demo.entity;

import java.io.Serializable;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotEmpty;

@Entity
@Table(name = "categories")
public class Category implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "CategoryId")
	private Integer id;

	@Column(name = "CategoryName", columnDefinition = "nvarchar(255) not null")
	@NotEmpty(message = "Tên thể loại không được phép rỗng")
	private String name;

	@Column(name = "Images", columnDefinition = "nvarchar(500) null")
	private String images;

	@Column(name = "Status")
	private int status = 1;

	public Category() {
	}

	public Category(Integer id, String name, String images, int status) {
		this.id = id;
		this.name = name;
		this.images = images;
		this.status = status;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getCategoryid() {
		return id;
	}

	public void setCategoryid(Integer categoryid) {
		this.id = categoryid;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getCategoryname() {
		return name;
	}

	public void setCategoryname(String categoryname) {
		this.name = categoryname;
	}

	public String getImages() {
		return images;
	}

	public void setImages(String images) {
		this.images = images;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}
}
