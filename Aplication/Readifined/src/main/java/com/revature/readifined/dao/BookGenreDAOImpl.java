package com.revature.readifined.dao;

import java.util.List;

import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import com.revature.readifined.domain.BookGenre;

@Repository
public class BookGenreDAOImpl implements BookGenreDAO {

	public SessionFactory sf;
	
	@Autowired
	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sf = sessionFactory;
	}
	
	@Override
	public BookGenre getBookGenre(int id) {
		Session sess = sf.openSession();
		BookGenre ap = sess.get(BookGenre.class, id);
		sess.close();
		return ap;
	}

	@Override
	public BookGenre getBookGenre(int value, String column) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		CriteriaBuilder cb = sess.getCriteriaBuilder();
		CriteriaQuery<BookGenre> cq = cb.createQuery(BookGenre.class);
		Root<BookGenre> rootEntry = cq.from(BookGenre.class);
		CriteriaQuery<BookGenre> all = cq.select(rootEntry).where(cb.equal(rootEntry.get(column), value));
		TypedQuery<BookGenre> allQuery = sess.createQuery(all);
		List<BookGenre> list = allQuery.getResultList();
		tx.commit();
		sess.close();
		return list.get(0);	
	}
	
	@Override
	public List<BookGenre> getBooksGenres(int value, String column) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		CriteriaBuilder cb = sess.getCriteriaBuilder();
		CriteriaQuery<BookGenre> cq = cb.createQuery(BookGenre.class);
		Root<BookGenre> rootEntry = cq.from(BookGenre.class);
		CriteriaQuery<BookGenre> all = cq.select(rootEntry).where(cb.equal(rootEntry.get(column), value));
		TypedQuery<BookGenre> allQuery = sess.createQuery(all);
		List<BookGenre> list = allQuery.getResultList();
		tx.commit();
		sess.close();
		return list;	
	}

	@Override
	public void saveBookGenre(BookGenre bg) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.save(bg);
		tx.commit();
		sess.close();
	}

	@Override
	public void updateBookGenre(BookGenre bg) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.update(bg);
		tx.commit();
		sess.close();
		
	}

	@Override
	public void deleteBookGenre(BookGenre bg) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.delete(bg);
		tx.commit();
		sess.close();
		
	}

}
