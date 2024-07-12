#tag Class
Protected Class XojoFrameworkTests
Inherits TestGroup
	#tag Event
		Sub Setup()
		  Locker = new Semaphore
		  Locker.Type = Thread.Types.Preemptive
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub CheckResults()
		  for each p as pair in Results
		    Assert.IsTrue p.Right, p.Left
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub MemoryBlockRunner(index As Integer, data As Variant)
		  var size as integer = System.Random.InRange( 1, 8 ) * 8
		  
		  var mb as new MemoryBlock( size )
		  var p as ptr = mb
		  
		  for loops as integer = 1 to 10
		    for i as integer = 0 to size - 1 step 8
		      p.Int64( i ) = i
		    next
		    
		    for i as integer = 0 to size - 1 step 8
		      if p.Int64( i ) = i and mb.Int64Value( i ) = i then
		        // Good
		      else
		        Store index, data, false
		        return
		      end if
		    next
		  next
		  
		  Store index, data, true
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MemoryBlockTest()
		  var tp as new DelegateRunnerThreadPool( AddressOf MemoryBlockRunner )
		  
		  for i as integer = 0 to kLastJobIndex
		    tp.Add i : nil
		  next
		  
		  tp.Wait
		  
		  CheckResults
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RegExRunner(index As Integer, data As Variant)
		  var source as string = data.StringValue
		  
		  var rx as new RegEx
		  
		  rx.SearchPattern = source.Left( 2 )
		  
		  if rx.Search( source ) isa RegExMatch then
		    Store index, source, true
		  else
		    Store index, source,  false
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RegExTest()
		  var masterSource as string = "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ"
		  var masterSourceArray() as string = masterSource.Split( "" )
		  
		  var tp as new DelegateRunnerThreadPool( AddressOf RegExRunner )
		  
		  for i as integer = 0 to kLastJobIndex
		    masterSourceArray.Shuffle
		    var s as string = String.FromArray( masterSourceArray, "" )
		    tp.Add i : s
		  next
		  
		  tp.Wait
		  
		  CheckResults
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SameMemoryBlockRunner(index As Integer, data As Variant)
		  var mb as MemoryBlock = data
		  var p as ptr = mb
		  
		  mb.Int64Value( index * 8 ) = index
		  
		  if not mb.Int64Value( index * 8 ) = index then
		    Store index, nil, false
		    return
		  end if
		  
		  p.Int64( index * 8 ) = index + kLastJobIndex + 1
		  Store index, nil, p.Int64( index * 8 ) = ( index + kLastJobIndex + 1 )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SameMemoryBlockTest()
		  var tp as new DelegateRunnerThreadPool( AddressOf SameMemoryBlockRunner )
		  
		  var mb as new MemoryBlock( ( kLastJobIndex + 1 ) * 8 )
		  
		  for i as integer = 0 to kLastJobIndex
		    tp.Add i : mb
		  next
		  
		  tp.Wait
		  
		  CheckResults
		  
		  for i as integer = 0 to kLastJobIndex
		    Assert.AreEqual i + kLastJobIndex + 1, mb.Int64Value( i * 8 )
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Store(index As Integer, source As Variant, result As Variant)
		  if Results.Count = 0 then
		    Locker.Signal
		    if Results.Count = 0 then
		      Results.ResizeTo kLastJobIndex
		    end if
		    Locker.Release
		  end if
		  
		  Results( index ) = source : result
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Locker As Semaphore
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Results() As Pair
	#tag EndProperty


	#tag Constant, Name = kLastJobIndex, Type = Double, Dynamic = False, Default = \"49", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Duration"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FailedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IncludeGroup"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
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
			Name="IsRunning"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
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
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="NotImplementedCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PassedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkippedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StopTestOnFail"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
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
			Name="TestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
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
