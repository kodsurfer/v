module main

import db.sqlite
import vweb
import time

struct App {
	vweb.Context
pub mut:
	db sqlite.DB
}

fn main(){
	mut app := App{
		db: sqlite.connect(':memory:')!
	}
	vweb.run(app, 8081)
}

@['/index']
pub fn (mut app App) index() vweb.Result {
	msg := 'Hello world from vweb!'
	return $vweb.html()
}

fn (mut app App) time() vweb.Result {
	return app.text(time.now().format())
}

@[post]
pub fn (mut app App) new_article(title string. text string) vweb.Result {
	if title == '' || text == '' {
		return app.text("empty text/title")
	}
	return app.redirect("/")
}
