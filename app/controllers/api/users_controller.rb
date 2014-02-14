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
			room = Room.new(:name => name, :latitude => lat, :longitude => long)
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
		else
			msg = { :status => "error", :message => "Error!", :html => "Error" }
		end
		respond_to do |format|
			format.json  { render :json => msg }
		end
	end

	def listlocalrooms
		user = getuser params
		if user
			lat = params[:lat]
			long = params[:long]
			msg = Room.near([lat, long], 1)
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
