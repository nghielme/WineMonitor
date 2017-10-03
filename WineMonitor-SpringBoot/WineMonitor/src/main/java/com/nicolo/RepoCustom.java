package com.nicolo;

import com.nicolo.Entity.Entry;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RepoCustom{
    List<Entry> getAll(Boolean all);
    List<Entry> getLT(Long max);
    List<Entry> getGT(Long min);
    List<Entry> getBetween(Long min, Long max);
   // HttpEntity postToCloud(Entry entry);
}

