package main
 
import (
	"net/http"
	"net/http/httptest"
	"testing"
)
 
func Test_home_handle(t *testing.T) {
	req := httptest.NewRequest(http.MethodGet, "/", nil)
	res := httptest.NewRecorder()
 
	home{}.handle(res, req)
 
	if res.Code != http.StatusOK {
		t.Error("expected 200 but got", res.Code)
	}
}
