package com.example.demo.entity;

import java.io.Serializable;
import java.sql.Date;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "[User]")
public class User implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Integer id;

	@Column(name = "email", columnDefinition = "nvarchar(255) null")
	private String email;

	@Column(name = "username", columnDefinition = "nvarchar(255) not null")
	private String username;

	@Column(name = "fullname", columnDefinition = "nvarchar(255) null")
	private String fullname;

	@Column(name = "password", columnDefinition = "nvarchar(255) not null")
	private String password;

	@Column(name = "avatar", columnDefinition = "nvarchar(255) null")
	private String avatar;

	@Column(name = "roleid")
	private int roleid = 3; // 1: Admin, 2: Manager, 3: User

	@Column(name = "phone", columnDefinition = "nvarchar(50) null")
	private String phone;

	@Column(name = "createddate")
	private Date createdDate;

	@Column(name = "status", columnDefinition = "int not null default 1")
	private int status = 1;

	@Column(name = "code", columnDefinition = "nvarchar(20) null")
	private String code;

	public User() {
	}

	public User(String email, String username, String fullname, String password, String avatar, int roleid,
			String phone, Date createdDate) {
		this.email = email;
		this.username = username;
		this.fullname = fullname;
		this.password = password;
		this.avatar = avatar;
		this.roleid = roleid;
		this.phone = phone;
		this.createdDate = createdDate;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getUserName() {
		return username;
	}

	public void setUserName(String userName) {
		this.username = userName;
	}

	public String getFullname() {
		return fullname;
	}

	public void setFullname(String fullname) {
		this.fullname = fullname;
	}

	public String getFullName() {
		return fullname;
	}

	public void setFullName(String fullName) {
		this.fullname = fullName;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getPassWord() {
		return password;
	}

	public void setPassWord(String passWord) {
		this.password = passWord;
	}

	public String getAvatar() {
		return avatar;
	}

	public void setAvatar(String avatar) {
		this.avatar = avatar;
	}

	public int getRoleid() {
		return roleid;
	}

	public void setRoleid(int roleid) {
		this.roleid = roleid;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public Date getCreatedDate() {
		return createdDate;
	}

	public void setCreatedDate(Date createdDate) {
		this.createdDate = createdDate;
	}

	public Date getCreateddate() {
		return createdDate;
	}

	public void setCreateddate(Date createddate) {
		this.createdDate = createddate;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}
}
