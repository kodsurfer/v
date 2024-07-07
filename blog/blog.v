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
		db: sqlite.connect('blog.db')!
	}

	sql app.db {
		create table Article
	}!

	article1 := Article{
		title: 'Hello World'
		text: 'V is great'
	}

	article2 := Article{
		title: 'Second post'
		text: 'What should be the next?'
	}
	
	sql app.db {
		insert article1 into Article
		insert article2 into Article
	}!
	vweb.run(app, 8081)
}

@['/index']
pub fn (mut app App) index() vweb.Result {
	articles := app.find_all_articles()
	return $vweb.html()
}

fn (mut app App) time() vweb.Result {
	return app.text(time.now().format())
}


@[post]
pub fn (mut app App) new_article(title string, text string) vweb.Result {
	if title == '' || text == '' {
		return app.text("empty text/title")
	}

	article := Article{
			title: title
			text: text
	}

	sql app.db {
		insert article into Article
	} or { panic(err) }

	return app.redirect("/")
}

@['/new']
pub fn (mut app App) new() vweb.Result {
	return $vweb.html()
}
