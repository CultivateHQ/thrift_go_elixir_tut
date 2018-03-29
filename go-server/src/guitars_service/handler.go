package main

import (
	"context"
	"sync"
	"thrift_generated/guitars"
)

type guitarsHandler struct {
	mutex      sync.RWMutex
	idSequence int64
	storage    map[int64]*guitars.Guitar
}

func newGuitarsHandler() *guitarsHandler {
	return &guitarsHandler{
		idSequence: 0,
		storage:    make(map[int64]*guitars.Guitar),
	}
}

func (p *guitarsHandler) Create(ctx context.Context, brand string, model string) (r *guitars.Guitar, err error) {
	p.mutex.Lock()
	defer p.mutex.Unlock()

	var guitar = guitars.NewGuitar()
	guitar.ID = p.idSequence
	guitar.Brand = brand
	guitar.Model = model

	p.storage[guitar.ID] = guitar

	p.idSequence++

	return guitar, nil
}

func (p *guitarsHandler) Show(ctx context.Context, id int64) (r *guitars.Guitar, err error) {
	p.mutex.RLock()
	defer p.mutex.RUnlock()

	r, ok := p.storage[id]

	if !ok {
		guitarsErr := guitars.NewError()
		guitarsErr.ErrCode = guitars.ErrorType_NO_SUCH_RECORD_ID
		err = guitarsErr
	}

	return r, err
}

func (p *guitarsHandler) Remove(ctx context.Context, id int64) (r *guitars.Guitar, err error) {
	p.mutex.Lock()
	defer p.mutex.Unlock()

	r, ok := p.storage[id]

	if ok {
		delete(p.storage, id)
	} else {
		guitarsErr := guitars.NewError()
		guitarsErr.ErrCode = guitars.ErrorType_NO_SUCH_RECORD_ID
		err = guitarsErr
	}

	return r, err
}

func (p *guitarsHandler) All(ctx context.Context) (r []*guitars.Guitar, err error) {
	p.mutex.RLock()
	defer p.mutex.RUnlock()

	r = make([]*guitars.Guitar, 0, len(p.storage))

	for _, elem := range p.storage {
		r = append(r, elem)
	}

	return r, nil
}
