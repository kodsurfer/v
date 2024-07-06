module main

import vweb

struct Article {
	id int @[primary; sql: serial]
	title string
	text string
}

pub fn (app &App) find_all_articles() []Article{
	return sql app.db {
		select from Article
	} or { panic(err) }
}

pub fn (app &App) get_article() ?Article{
	return sql app.db {
		select from Article limit 1
	} or { panic(err) } [0]
}

@['/articles'; get]
pub fn (mut app App) articles() vweb.Result {
	articles := app.find_all_articles()
	return app.json (articles)
}
