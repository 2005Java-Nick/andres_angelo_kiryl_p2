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

import com.revature.readifined.domain.Tag;

@Repository
public class TagDAOImpl implements TagDAO{

    private SessionFactory sf;
	
	@Autowired
	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sf = sessionFactory;
	}
	
	@Override
	public Tag getTag(int id) {
		Session sess = sf.openSession();
		Tag tag = sess.get(Tag.class, id);
		sess.close();
		return tag;
	}

	@Override
	public Tag getTag(String value, String column) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		CriteriaBuilder cb = sess.getCriteriaBuilder();
		CriteriaQuery<Tag> cq = cb.createQuery(Tag.class);
		Root<Tag> rootEntry = cq.from(Tag.class);
		CriteriaQuery<Tag> all = cq.select(rootEntry).where(cb.equal(rootEntry.get(column), value));
		TypedQuery<Tag> allQuery = sess.createQuery(all);
		List<Tag>list=allQuery.getResultList();
		tx.commit();
		sess.close();
		return list.get(0);
	}

	@Override
	public void saveTag(Tag t) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.save(t);
		tx.commit();
		sess.close();
		
	}

	@Override
	public void updateTag(Tag t) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.update(t);
		tx.commit();
		sess.close();
		
	}

	@Override
	public void deleteTag(Tag tag) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.delete(tag);
		tx.commit();
		sess.close();
		
	}

	
}
