package com.nicolo;

import com.nicolo.Entity.Entry;
import org.bson.types.ObjectId;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

/*
    Attenzione ai nomi:
    - xxx (in questo caso repo) -> nome dell'interfaccia che intendiamo utilizzare.
    - xxxCustom -> nome dell'interfaccia con le funzioni che vogliamo implementare.
    - xxxImpl -> nome della classe che implementa le funzioni dichiarate in xxxCustom.

    Se non si segue questo pattern springBoot non compila!
 */

@Repository
public interface Repo extends RepoCustom,MongoRepository<Entry,ObjectId> {}
