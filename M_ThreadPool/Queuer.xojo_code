#tag Class
Private Class Queuer
	#tag Method, Flags = &h0
		Sub Add(data As Pair)
		  var lock as new Locker( MySemaphore )
		  self.Data.Add data
		  lock = nil
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  MySemaphore = new Semaphore
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Count() As Integer
		  var lock as new M_ThreadPool.Locker( MySemaphore )
		  
		  var result as integer = Data.Count
		  
		  lock = nil
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveAll()
		  var lock as new M_ThreadPool.Locker( MySemaphore )
		  
		  Data.RemoveAll
		  
		  lock = nil
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TryPop(ByRef data As Pair) As Boolean
		  var lock as new Locker( MySemaphore )
		  
		  var result as boolean
		  
		  if self.Data.Count <> 0 then
		    data = self.Data( 0 )
		    self.Data.RemoveAt 0
		    result = true
		  end if
		  
		  lock = nil
		  
		  return result
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Data() As Pair
	#tag EndProperty

	#tag Property, Flags = &h21
		Private MySemaphore As Semaphore
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
