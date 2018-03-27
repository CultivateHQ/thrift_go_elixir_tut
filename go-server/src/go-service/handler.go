package main

import (
	"context"
	"gen-go/guitars"
)

type guitarsHandler struct {
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
	var guitar = guitars.NewGuitar()
	guitar.ID = p.idSequence
	guitar.Brand = brand
	guitar.Model = model

	p.storage[guitar.ID] = guitar

	p.idSequence++

	return guitar, nil
}

func (p *guitarsHandler) Show(ctx context.Context, id int64) (r *guitars.Guitar, err error) {
	r, ok := p.storage[id]

	if !ok {
		guitarsErr := guitars.NewError()
		guitarsErr.ErrCode = guitars.ErrorType_NO_SUCH_RECORD_ID
		err = guitarsErr
	}

	return r, err
}

func (p *guitarsHandler) Remove(ctx context.Context, id int64) (r *guitars.Guitar, err error) {
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
	r = make([]*guitars.Guitar, 0, len(p.storage))

	for _, elem := range p.storage {
		r = append(r, elem)
	}

	return r, nil
}
