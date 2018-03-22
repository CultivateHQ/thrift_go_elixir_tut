package main

import (
	"context"
	"gen-go/guitars"
)

type guitarsHandler struct {
	idSequence int64
	storage    []*guitars.Guitar
}

func newGuitarsHandler() *guitarsHandler {
	return &guitarsHandler{
		idSequence: 0,
		storage:    make([]*guitars.Guitar, 0, 10),
	}
}

func (p *guitarsHandler) Create(ctx context.Context, brand string, model string) (r *guitars.Guitar, err error) {
	var guitar = guitars.NewGuitar()
	guitar.ID = p.idSequence
	guitar.Brand = brand
	guitar.Model = model

	p.storage = append(p.storage, guitar)

	p.idSequence++

	return guitar, nil
}

func (p *guitarsHandler) Show(ctx context.Context, id int64) (r *guitars.Guitar, err error) {
	for _, guitar := range p.storage {
		if guitar != nil && guitar.GetID() == id {
			r = guitar
			break
		}
	}

	if r == nil {
		guitarsErr := guitars.NewError()
		guitarsErr.ErrCode = guitars.ErrorType_NO_SUCH_RECORD_ID
		err = guitarsErr
	}

	return r, err
}

func (p *guitarsHandler) Remove(ctx context.Context, id int64) (r *guitars.Guitar, err error) {
	index := -1
	for i, guitar := range p.storage {
		if guitar.GetID() == id {
			r = guitar
			index = i
			break
		}
	}

	if r != nil {
		p.storage[index] = nil
	} else {
		guitarsErr := guitars.NewError()
		guitarsErr.ErrCode = guitars.ErrorType_NO_SUCH_RECORD_ID
		err = guitarsErr
	}

	return r, err
}

func (p *guitarsHandler) All(ctx context.Context) (r []*guitars.Guitar, err error) {
	return p.storage, nil
}
