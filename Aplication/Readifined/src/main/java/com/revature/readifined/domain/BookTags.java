package com.revature.readifined.domain;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "readifined.book_tags")
public class BookTags implements Serializable{

	private static final long serialVersionUID = 3739097466270305276L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	int id;
	@Column(name = "book_id")
	int bookId;
	@Column(name = "tag_id")
	int tagId;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getBookId() {
		return bookId;
	}
	public void setBookId(int bookId) {
		this.bookId = bookId;
	}
	public int getTagId() {
		return tagId;
	}
	public void setTagId(int tagId) {
		this.tagId = tagId;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + bookId;
		result = prime * result + id;
		result = prime * result + tagId;
		return result;
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		BookTags other = (BookTags) obj;
		if (bookId != other.bookId)
			return false;
		if (id != other.id)
			return false;
		if (tagId != other.tagId)
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "BookTags [id=" + id + ", bookId=" + bookId + ", tagId=" + tagId + "]";
	}
	
	
}
