package main

import (
	"context"
	"testing"
	"thrift_generated/guitars"
)

func TestNewGuitarsHandler(t *testing.T) {
	shouldImplementHandlerInterface := func(handler guitars.Guitars) {}

	var handler = newGuitarsHandler()
	shouldImplementHandlerInterface(handler)
}
func TestCreate(t *testing.T) {
	var record *guitars.Guitar
	var err error
	var handler = newGuitarsHandler()

	record, err = handler.Create(context.Background(), "Gibson", "Les Paul")
	expectNoErr(t, err)
	expectGuitarMatching(t, record, 0, "Gibson", "Les Paul")

	record, err = handler.Create(context.Background(), "Charvel", "San Dimas")
	expectNoErr(t, err)
	expectGuitarMatching(t, record, 1, "Charvel", "San Dimas")
}

func TestShow(t *testing.T) {
	var record *guitars.Guitar
	var err error
	var handler = newGuitarsHandler()

	_, err = handler.Show(context.Background(), 0)
	expectErr(t, err, guitars.ErrorType_NO_SUCH_RECORD_ID)

	record, err = handler.Create(context.Background(), "Gibson", "Les Paul")
	expectNoErr(t, err)
	record, err = handler.Show(context.Background(), record.GetID())
	expectNoErr(t, err)
	expectGuitarMatching(t, record, 0, "Gibson", "Les Paul")

	record, err = handler.Create(context.Background(), "Charvel", "San Dimas")
	expectNoErr(t, err)
	record, err = handler.Show(context.Background(), record.GetID())
	expectNoErr(t, err)
	expectGuitarMatching(t, record, 1, "Charvel", "San Dimas")
}

func TestRemove(t *testing.T) {
	var record *guitars.Guitar
	var err error
	var handler = newGuitarsHandler()

	record, err = handler.Create(context.Background(), "Gibson", "Les Paul")
	expectNoErr(t, err)

	record, err = handler.Show(context.Background(), record.GetID())
	expectNoErr(t, err)
	expectGuitarMatching(t, record, 0, "Gibson", "Les Paul")

	record, err = handler.Remove(context.Background(), record.GetID())
	expectNoErr(t, err)
	expectGuitarMatching(t, record, 0, "Gibson", "Les Paul")

	_, err = handler.Show(context.Background(), record.GetID())
	expectErr(t, err, guitars.ErrorType_NO_SUCH_RECORD_ID)
}

func TestAll(t *testing.T) {
	var records []*guitars.Guitar
	var err error
	var handler = newGuitarsHandler()

	records, err = handler.All(context.Background())
	expectNoErr(t, err)
	expectEmpty(t, records)

	handler.Create(context.Background(), "Gibson", "Les Paul")
	records, err = handler.All(context.Background())
	expectNoErr(t, err)
	expectLen(t, records, 1)
	expectGuitarMatching(t, records[0], 0, "Gibson", "Les Paul")

	handler.Create(context.Background(), "Charvel", "San Dimas")
	records, err = handler.All(context.Background())
	expectNoErr(t, err)
	expectLen(t, records, 2)
	expectGuitarMatching(t, records[0], 0, "Gibson", "Les Paul")
	expectGuitarMatching(t, records[1], 1, "Charvel", "San Dimas")
}

func expectGuitarMatching(
	t *testing.T,
	guitar *guitars.Guitar,
	expectedID int64,
	expectedBrand string,
	expectedModel string) {

	if guitar.GetID() != expectedID {
		t.Errorf("Expected record ID to be %d but was %d", expectedID, guitar.GetID())
	}

	if guitar.GetBrand() != expectedBrand {
		t.Errorf("Expected record Brand to be '%s' but was '%s'", expectedBrand, guitar.GetBrand())
	}

	if guitar.GetModel() != expectedModel {
		t.Errorf("Expected record Model to be '%s' but was '%s'", expectedModel, guitar.GetModel())
	}
}

func expectErr(t *testing.T, actual error, expectedErrCode guitars.ErrorType) {
	if e, ok := actual.(*guitars.Error); ok {
		if e.GetErrCode() != expectedErrCode {
			t.Errorf("Expected err to be '%s' but was '%s'", expectedErrCode, e.GetErrCode())
		}
	}
}

func expectNoErr(t *testing.T, err error) {
	if err != nil {
		t.Errorf("Expected no err but was '%s'", err.Error())
	}
}

func expectEmpty(t *testing.T, records []*guitars.Guitar) {
	if len(records) != 0 {
		t.Errorf("Expected empty array but had %d elements", len(records))
	}
}

func expectLen(t *testing.T, records []*guitars.Guitar, expectedLen int) {
	if len(records) != expectedLen {
		t.Errorf("Expected %d element array but had %d elements", expectedLen, len(records))
	}
}
