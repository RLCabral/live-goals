class FrontController < ApplicationController

	require "rexml/document"
	include REXML    # so that we don't have to prefix everything with
	                 # REXML::...




	def index
		@jogos_on = LiveGame.find_by_sql('SELECT equipa1, equipa2, golos1, golos2, id FROM live_games where flag = \'on\' order by id;')
		@vid_recente = Vid.find_by_sql('SELECT * from vids order by data desc limit 10')

		@ult_resultados = LiveGame.find_by_sql('SELECT * from live_games where flag = \'off\' order by data desc')


		@rss = 'http://news.google.pt/?ned=pt-PT_pt&topic=s&output=rss'
		@content = Net::HTTP.get(URI.parse(@rss))
		xml = Document.new(@content)

		data = {}
		@news_text = "<div><img src='images/t_news.png' style='vertical-align: top' /> [<a href='" + xml.root.elements['channel/link'].text + "' target='_blank' rel='Ver todas as notícias'>mais</a>]</div>"
		data['items'] = []
		i = 0
		xml.elements.each('//item') do |item|
			it = {}

			if item.elements['dc:creator']
			end
			if item.elements['dc:date']
			elsif item.elements['pubDate']
				@news_text << "<div style='width:120px; padding:0px 2px 0px 3px'>" + item.elements['pubDate'].text.slice(4,21) + "</div>"
			end
			@news_text << "<a href='" + item.elements['link'].text + "' target='_blank'  rel='Mais detalhes" + "'><div class='list_news'>" + item.elements['title'].text + "</div></a>"
			i += 1
			break if i == 3
		end

	end

	def lista_lances

	render :text => "Adicionado"

	end

end
