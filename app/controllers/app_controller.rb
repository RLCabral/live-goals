class AppController < ApplicationController

	require "rexml/document"
	include REXML    # so that we don't have to prefix everything with
	                 # REXML::...

	def criar

	end

	def criar_game #Create a new match. First create it into the DB and then create a new xml file based on the new ID. It means, ID=15, then the file will be 15.xml
		@jogo = LiveGame.new()
		@jogo.equipa1 = params[:equipa1]
		@jogo.equipa2 = params[:equipa2]
		#because every match start 0 x 0
		@jogo.golos1 = 0
		@jogo.golos2 = 0
		@jogo.data = params[:data]
		@jogo.hora = params[:hora]
		@jogo.torneio = "" #for now this field is not being in use
		@jogo.save
		resultado_sql = LiveGame.find_by_sql('SELECT id FROM live_games order by id desc limit 1;') #what was the ID given to the new match?
		for tabela in resultado_sql
			jogo_id = tabela.id.to_s #Here is the answer... the new ID is now available into the jogo_id		end

		nome_ficheiro = "games/" + jogo_id + ".xml"
		render :text => "Jogo criado... Ficheiro guardado em: " + nome_ficheiro
		novo_ficheiro = File.new(nome_ficheiro, "w+")

		doc = Document.new File.new("games/sample.xml")
		root = doc.root

		detalhes = Element.new "detalhes"
		detalhes.attributes["id"] = jogo_id

		detalhes.add_element "equipa1"
		detalhes.elements["equipa1"].text = params[:equipa1]

		detalhes.add_element "equipa2"
		detalhes.elements["equipa2"].text = params[:equipa2]

		detalhes.add_element "golos1"
		detalhes.elements["golos1"].text = 0

		detalhes.add_element "golos2"
		detalhes.elements["golos2"].text = 0

		detalhes.add_element detalhes

		root.add_element detalhes

		print doc

		ficheiro = File.new(nome_ficheiro, "w+")
		ficheiro.puts doc
		ficheiro.close
	end

	def procurar
		#not implemented yet
	end

	def actualiza_db
		#not implemented yet
	end

	def actualiza_xml
		@jogos_on = LiveGame.find_by_sql('SELECT * FROM live_games where flag = \'on\' order by id;')
	end

	def actualiza_xml_f #add a new match event in the xml file

		nome_ficheiro = "games/" + params[:jogo_id] + ".xml"

		doc = Document.new File.new(nome_ficheiro)
		root = doc.root

		lance = Element.new "lance"
		lance.attributes["minuto"] = params[:minuto]

		lance.add_element "lance"
		lance.elements["lance"].text  = params[:lance]

		lance.add_element "desc"
		if params[:lance] == "Vídeo" #video
			lance.elements["desc"].text  = params[:desc]
			lance.add_element lance
			resultado_sql = LiveGame.find_by_sql('SELECT * FROM live_games where id =' + params[:jogo_id] + ';')
			for tabela in resultado_sql
				equipa1 = tabela.equipa1.to_s
				equipa2 = tabela.equipa2.to_s
			end
			novo_vid = Vid.new()
			novo_vid.cod = params[:desc]
			novo_vid.data = DateTime.now()
			novo_vid.equipa1 = equipa1
			novo_vid.equipa2 = equipa2
			novo_vid.save
		end

		if params[:lance] == "Lance normal" #normal event
			lance.elements["desc"].text  = params[:desc]
			lance.add_element lance
		end

		if params[:lance] == "Cartão Amarelo" #yellow card
			lance.elements["desc"].text  = params[:desc]
			lance.add_element lance
		end

		if params[:lance] == "Cartão Vermelho" #red card
			lance.elements["desc"].text  = params[:desc]
			lance.add_element lance
		end

		if params[:lance] == "Golo" #Goals
			lance.elements["desc"].text  = params[:desc]
			lance.add_element lance
		end

		root.add_element lance

		print doc

		ficheiro = File.new(nome_ficheiro, "w+")
		ficheiro.puts doc
		ficheiro.close

		render :text => params[:jogo_id] #just to be sure it updated the right match
	end

	def actualiza_db
		@jogos_on = LiveGame.find_by_sql('SELECT * FROM live_games where flag = \'on\' order by id;')
	end

	def actualiza_db_f #change the match result (goals) in the db
		@jogo = LiveGame.find(params[:jogo_id])
		@jogo.golos1 = params[:golos1]
		@jogo.golos2 = params[:golos2]
		@jogo.save
		redirect_to :action => "actualiza_db"
	end

	def fecha_jogo_l
		@jogos_on = LiveGame.find_by_sql('SELECT * FROM live_games where flag = \'on\' order by id;')

	end

	def fecha_jogo #close a match, which means that it will not be able to add or change anything info about the match
		@jogo = LiveGame.find(params[:id])
		@jogo.flag = "off"
		@jogo.golos1 = params[:golos1]
		@jogo.golos2 = params[:golos2]
		@jogo.save
		redirect_to :action => "fecha_jogo_l"

	end

	def lista_jogos

	end

	def lista_lances #list the events to show up in the index view. It lists the events and the last 2 matches of each team

		session[:jo] = params[:id]

		doc = Document.new File.new("games/" + session[:jo].to_s + ".xml")

		@desc = Array.new
		@min = Array.new
		@lance_tipo = Array.new
		@arr_det = Array.new
		doc.elements.each("Jogo/detalhes/equipa1") { |element| @equipa1 = element.text.to_s }
		doc.elements.each("Jogo/detalhes/equipa2") { |element|	@equipa2 = element.text.to_s }
		doc.elements.each("Jogo/detalhes/golos1") { |element|	@golos1 = element.text.to_s }
		doc.elements.each("Jogo/detalhes/golos2") { |element|	@golos2 = element.text.to_s }
		doc.elements.each("Jogo/lance/desc") { |element| @desc << element.text.to_s }
		doc.elements.each("Jogo/lance/lance") { |element| @lance_tipo << element.text.to_s }
		doc.elements.each("Jogo/lance") { |element| @min << element.attributes["minuto"] }

		@arr_size = @desc.length
		@arr_size.times { |i| 
			@arr_det << "<div style=\"background:#eee; float:left; width:34px; text-align:right; padding-right:10px\">" + @min[i] + "</div> <div style=\"text-align:left\">" + @desc[i] + "</div>" }

		@ult_jogos1 = LiveGame.find_by_sql('SELECT * from live_games where flag = \'off\' AND equipa1 = \'' + params[:e1].to_s + '\' order by data desc limit 2')
		@ult_jogos2 = LiveGame.find_by_sql('SELECT * from live_games where flag = \'off\' AND equipa1 = \'' + params[:e2].to_s + '\' order by data desc limit 2')

		@lst_e1 = params[:e1].to_s
		@lst_e2 = params[:e2].to_s

	end

	def update_lances #this is the action which the periodically_call_remote calls in the index page, it only update the events

			doc = Document.new File.new("games/" + session[:jo].to_s + ".xml")

			@desc = Array.new
			@min = Array.new
			@lance_tipo = Array.new
			@arr_det = Array.new
			doc.elements.each("Jogo/detalhes/equipa1") { |element| @equipa1 = element.text.to_s }
			doc.elements.each("Jogo/detalhes/equipa2") { |element|	@equipa2 = element.text.to_s }
			doc.elements.each("Jogo/detalhes/golos1") { |element|	@golos1 = element.text.to_s }
			doc.elements.each("Jogo/detalhes/golos2") { |element|	@golos2 = element.text.to_s }
			doc.elements.each("Jogo/lance/desc") { |element| @desc << element.text.to_s }
			doc.elements.each("Jogo/lance/lance") { |element| @lance_tipo << element.text.to_s }
			doc.elements.each("Jogo/lance") { |element| @min << element.attributes["minuto"] }
			@arr_size = @desc.length
			@arr_size.times { |i| 
				@arr_det << "<div style=\"background:#eee; float:left; width:34px; text-align:right; padding-right:10px\">" + @min[i] + "</div> <div style=\"text-align:left\">" + @desc[i] + "</div>" }

	end


	def embed_video #embed the video into the index view
		render :text => "<embed src='http://futebol.videos.sapo.pt/play-bwin?file=http://futebol.videos.sapo.pt/" + params[:var] + "/mov/1' type='application/x-shockwave-flash' width='400' height='360' wmode='transparent'></embed>"
		puts params[:var]
	end

	def jogo_selected #I think it is not easy to know what is the match only listing the ID, so when I click on the listbox the teams are showed in a div. Here is the action which find the match in the db
		@jogos_on = LiveGame.find_by_sql('SELECT * FROM live_games where id = ' + params[:query] + ';')
		for table in @jogos_on
			render :text => table.equipa1 + "<b>" + table.golos1.to_s + "</b> x <b>" + table.golos2.to_s + "</b> " + table.equipa2
		end
	
	end

end
