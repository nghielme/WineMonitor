package com.nicolo.Controller;

import com.nicolo.Entity.Entry;
import com.nicolo.Repo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/entries")
public class EntryController {

    @Autowired
    private Repo repository;

    @CrossOrigin
    @RequestMapping(method = RequestMethod.GET)
    public List<Entry> getAllEntries(){
        return repository.getAll(false);
    }

    @CrossOrigin
    @RequestMapping(params = {"all"},method = RequestMethod.GET)
    public List<Entry> getAllEntries(@RequestParam("all") boolean all){
        return repository.getAll(true);
    }

    @CrossOrigin
    @RequestMapping(params = {"max"},method = RequestMethod.GET)
    public List<Entry> getLessThanEntries(@RequestParam("max") long max){
        return repository.getLT(max);
    }

    @CrossOrigin
    @RequestMapping(params = {"min"},method = RequestMethod.GET)
    public List<Entry> getGreaterThanEntries(@RequestParam("min") long min){
        return repository.getGT(min);
    }

    @CrossOrigin
    @RequestMapping(params = {"min","max"},method = RequestMethod.GET)
    public List<Entry> getBetweenEntries(@RequestParam("min") long min, @RequestParam("max") long max){
        return repository.getBetween(min,max);
    }

    @RequestMapping(method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<String> insertEntry(@RequestBody Entry entry){
        repository.save(entry);
        return new ResponseEntity<>(HttpStatus.CREATED);
    }
}