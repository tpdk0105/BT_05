package com.example.demo.entity;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "products")
public class Product implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "ProductId")
	private Integer id;

	@Column(name = "ProductName", columnDefinition = "nvarchar(255) not null")
	private String name;

	@Column(name = "Price", precision = 18, scale = 0)
	private BigDecimal price = BigDecimal.ZERO;

	@Column(name = "Quantity")
	private int quantity;

	@Column(name = "Description", columnDefinition = "nvarchar(1000) null")
	private String description;

	@Column(name = "Images", columnDefinition = "nvarchar(500) null")
	private String images;

	@Column(name = "Status")
	private int status = 1;

	@Column(name = "CreatedDate")
	private Timestamp createdDate;

	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "CategoryId")
	private Category category;

	public Product() {
	}

	public Integer getId() { return id; }
	public void setId(Integer id) { this.id = id; }
	public String getName() { return name; }
	public void setName(String name) { this.name = name; }
	public BigDecimal getPrice() { return price; }
	public void setPrice(BigDecimal price) { this.price = price; }
	public int getQuantity() { return quantity; }
	public void setQuantity(int quantity) { this.quantity = quantity; }
	public String getDescription() { return description; }
	public void setDescription(String description) { this.description = description; }
	public String getImages() { return images; }
	public void setImages(String images) { this.images = images; }
	public int getStatus() { return status; }
	public void setStatus(int status) { this.status = status; }
	public Timestamp getCreatedDate() { return createdDate; }
	public void setCreatedDate(Timestamp createdDate) { this.createdDate = createdDate; }
	public Category getCategory() { return category; }
	public void setCategory(Category category) { this.category = category; }
}
