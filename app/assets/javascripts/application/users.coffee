App.Page.on 'users_index',->
	return{
		ready:->
			#alert('users_index')
		destroy:->
			#alert('destory')
	}