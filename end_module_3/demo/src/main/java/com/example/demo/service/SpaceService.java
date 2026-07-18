package com.example.demo.service;

import com.example.demo.entity.Space;
import com.example.demo.repository.ISpaceRepository;
import com.example.demo.repository.SpaceRepository;

import java.util.List;

public class SpaceService implements ISpaceService{
    private final ISpaceRepository spaceRepository;
    public SpaceService() {
        this.spaceRepository = new SpaceRepository();
    }
    @Override
    public List<Space> findAll() {
        return spaceRepository.findAll();
    }

    @Override
    public Space findByID(String id) {
        if (id == null || id.trim().isEmpty()) {
            return null;
        }
        return spaceRepository.findByID(id.trim());
    }


    @Override
    public boolean save(Space space) {
        if (space == null) {
            return false;
        }
        return spaceRepository.save(space);
    }

    @Override
    public boolean delete(String id) {
        if (id == null || id.trim().isEmpty()) {
            return false;
        }
        return spaceRepository.delete(id.trim());
    }

    @Override
    public boolean update(Space space) {
        if (space == null || space.getId() == null) {
            return false;
        }
        return spaceRepository.update(space);
    }


    @Override
    public List<Space> search(String type, Integer floor) {
        return spaceRepository.search(type, floor);
    }
}
