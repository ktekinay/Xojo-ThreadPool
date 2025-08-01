#tag Class
Protected Class ThreeN1ThreadPool
Inherits ThreadPoolTestBase
	#tag Event , Description = 496D706C656D656E7420746F2068616E646C652070726F63657373696E67206F66206F6E65206974656D206F6620646174612E
		Sub Process(data As Variant)
		  'var start as double = System.Microseconds
		  
		  var value as integer = data.IntegerValue
		  
		  if value = 0 then
		    System.DebugLog "Got null value"
		    return
		  end if
		  
		  while value <> 1
		    if ( value mod 2 ) = 0 then
		      value = value \ 2
		    else
		      value = 3 * value + 1
		    end if
		  wend
		  
		  'while ( System.Microseconds - start ) < 20000
		  'wend
		  
		  AddUserInterfaceUpdate data : nil
		  
		  ResultLock.Type = self.Type
		  
		  ResultLock.Enter
		  
		  var currentResult as integer = Result
		  var expectedResult as integer = currentResult + data.IntegerValue
		  
		  Result = Result + data.IntegerValue
		  
		  if Result <> expectedResult then
		    break
		  end if
		  
		  Inputs.Add data.IntegerValue
		  
		  ResultLock.Leave
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Constructor(testName As String)
		  // Calling the overridden superclass constructor.
		  Super.Constructor( testName )
		  
		  ResultLock = new CriticalSection
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Inputs() As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Result As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ResultLock As CriticalSection
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="ElapsedMicroseconds"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MaximumJobs"
			Visible=true
			Group="Behavior"
			InitialValue="4"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ActiveJobs"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsQueueFull"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TestName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RemainingInQueue"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
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
		#tag ViewProperty
			Name="IsFinished"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="QueueLimit"
			Visible=false
			Group="Behavior"
			InitialValue="8"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Result"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
