package com.nicolo;

import com.nicolo.Entity.Entry;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoOperations;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.http.ResponseEntity;

import java.io.IOException;
import java.util.*;

public class RepoImpl implements RepoCustom {

    @Autowired
    private MongoOperations mongoOperations;

    @Override
    public List<Entry> getAll(Boolean all){
        if(all) return mongoOperations.findAll(Entry.class);
        Long time = new Date().getTime();
        Date date = new Date(time - time % (24 * 60 * 60 * 1000));
        Query query = new Query();
        query.fields().exclude("_id");
        query.addCriteria(Criteria.where("timestamp").gt(date.getTime()/1000));
        return mongoOperations.find(query,Entry.class);
    }

    @Override
    public List<Entry> getLT(Long max) {
        Query query = new Query();
        query.fields().exclude("_id");
        query.addCriteria(Criteria.where("timestamp").lt(max));
        return mongoOperations.find(query,Entry.class);
    }

    @Override
    public List<Entry> getGT(Long min) {
        Query query = new Query();
        query.fields().exclude("_id");
        query.addCriteria(Criteria.where("timestamp").gt(min));
        return mongoOperations.find(query,Entry.class);
    }

    @Override
    public List<Entry> getBetween(Long min, Long max) {
        Query query = new Query();
        query.fields().exclude("_id");
        query.addCriteria(Criteria.where("timestamp").lt(max).andOperator(Criteria.where("timestamp").gt(min)));
        return mongoOperations.find(query,Entry.class);
    }
}
