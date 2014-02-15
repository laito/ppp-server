class Api::UsersController < ApplicationController
    skip_before_filter :verify_authenticity_token
	require 'securerandom'

	def new
		username = params[:name]
		secret = SecureRandom.hex
		user = User.new(name: username, password: secret, password_confirmation: secret)
		user.save
		msg = { :status => "ok", :message => "Success!", :html => secret }
		respond_to do |format|
			format.json  { render :json => msg }
			format.html  { render :json => msg }
		end
	end


	def login
		user = getuser params
		if user
				msg = { :status => "ok", :message => "Success!", :html => "You have been logged in" }
			else
				msg = { :status => "error", :message => "Error!", :html => "Incorrect Credentials" }
		end
		respond_to do |format|
			format.json  { render :json => msg }
		end
	end

	def newroom
		user = getuser params
		if user
			name = params[:roomname]
			if params[:roomkey].blank?
				key = -1
			else
				key = params[:roomkey]
			end
			lat = params[:latitude]
			long = params[:longitude]
			room = Room.new(:name => name, :latitude => lat, :longitude => long, :user_id => user.id)
			if key != -1
				room.key = key
			end
			room.save
			msg = { :status => "ok", :message => "Success!", :html => "New Room Created" }
		else
			msg = { :status => "error", :message => "Error!", :html => "Error" }
		end
		respond_to do |format|
			format.json  { render :json => msg }
			format.html  { render :json => msg }
		end
	end


	def gallery
		user = getuser params
		msg = { :status => "error", :message => "Error!", :html => "Error" }
		if user
			roomid = params[:roomid]
			room = user.rooms.find(roomid)
			if room?
				format.json { render json: room.photos, status: :created }
			end
		end
		respond_to do |format|
			format.json  { render :json => msg }
		end
	end

	def listrooms
		user = getuser params
		if user
			msg = user.rooms
			respond_to do |format|
				format.json  { render :json => msg.as_json(:methods => [:thumb]) } #render :json => msg }
				format.html  { render :json => msg.as_json(:methods => [:thumb]) } #render :json => msg }
			end
			#respond_with({
			#  :rooms => msg.as_json(:methods => [:thumb]),
			#})
			return
		else
			msg = { :status => "error", :message => "Error!", :html => "Error" }
		end
		respond_to do |format|
			format.json  { render :json => msg }
			format.html  { render :json => msg }
		end
	end

	def joinroom
		user = getuser params
		msg = { :status => "error", :message => "Error!", :html => "Error" }
		if user
			roomid = params[:roomid]
			room = Room.find(roomid)
			auth = false
			if room.key != -1
				if not params[:key].blank?
					if room.key.eql? params[:key]
						auth = true
					end
				end
			else
				auth = true
			end
			if (not room.blank?) and auth
				roomie = Roomie.new(:room_id => room.id, :user_id => user.id)
				if roomie.save
					msg = { :status => "ok", :message => "Success!", :html => "Room joined" }
				end
			end
		end
		respond_to do |format|
			format.json  { render :json => msg }
		end
	end

	def joinedrooms
		user = getuser params
		if user
			roomies = Roomie.where("user_id = ?",user.id)
			rooms = []
			roomies.each do |roomie|
				room = roomie.room
				rooms.append(room)
			end
			msg = rooms
			msg = msg.as_json(:methods => [:thumb])
		else
			msg = { :status => "error", :message => "Error!", :html => "Error" }
		end
		respond_to do |format|
			format.json  { render :json => msg }
			format.html  { render :json => msg }
		end
	end

	def listlocalrooms
		user = getuser params
		if user
			lat = params[:latitude]
			long = params[:longitude]
			msg = Room.near([lat, long], 1)
			msg = msg.as_json(:methods => [:thumb])
		else
			msg = { :status => "error", :message => "Error!", :html => "Error" }
		end
		respond_to do |format|
			format.json  { render :json => msg }
		end
	end

	def newphoto
		user = getuser params
		if user
			@picture = Photo.new(params[:photo])
			roomid = params[:roomid]
			@picture.room_id = roomid
			@picture.user_id = user.id
			respond_to do |format|
			    if @picture.save
			      format.json { render json: @picture, status: :created }
			    else
			      format.json { render json: @picture.errors, status: :unprocessable_entity }
			    end
			end
		end
	end
end
