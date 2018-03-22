package main

import (
	"context"
	"gen-go/guitars"
)

type guitarsHandler struct {
}

func newGuitarsHandler() *guitarsHandler {
	return &guitarsHandler{}
}

func (p *guitarsHandler) Create(ctx context.Context, brand string, model string) (r *guitars.Guitar, err error) {
	return guitars.NewGuitar(), nil
}

func (p *guitarsHandler) Show(ctx context.Context, id int64) (r *guitars.Guitar, err error) {
	return guitars.NewGuitar(), nil
}

func (p *guitarsHandler) Remove(ctx context.Context, id int64) (r *guitars.Guitar, err error) {
	return guitars.NewGuitar(), nil
}

func (p *guitarsHandler) All(ctx context.Context) (r []*guitars.Guitar, err error) {
	return []*guitars.Guitar{guitars.NewGuitar()}, nil
}
