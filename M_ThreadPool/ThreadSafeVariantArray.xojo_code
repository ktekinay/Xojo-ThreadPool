#tag Class
Class ThreadSafeVariantArray
Implements Iterable
	#tag Method, Flags = &h0
		Sub Add(item As Variant)
		  MySemaphore.Signal
		  
		  self.Data.Add item
		  
		  MySemaphore.Release
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddAt(index As Integer, item As Variant)
		  MySemaphore.Signal
		  
		  Data.AddAt( index, item )
		  
		  MySemaphore.Release
		  
		  Exception err as RuntimeException
		    try
		      MySemaphore.Release
		    end try
		    
		    raise err
		    
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  MySemaphore = new Semaphore
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IndexOf(item As Variant) As Integer
		  MySemaphore.Signal
		  
		  var result as integer = Data.IndexOf( item )
		  
		  MySemaphore.Release
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Function Iterator() As Iterator
		  MySemaphore.Signal
		  
		  var newArr() as variant
		  newArr.ResizeTo Data.LastIndex
		  
		  for i as integer = 0 to Data.LastIndex
		    newArr( i ) = Data( i )
		  next
		  
		  MySemaphore.Release
		  
		  return new M_ThreadPool.ThreadSafeVariantArrayIterator( newArr )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Function Operator_Convert() As Variant()
		  MySemaphore.Signal
		  
		  var result() as variant
		  result.ResizeTo Data.LastIndex
		  
		  for i as integer = 0 to Data.LastIndex
		    result( i ) = Data( i )
		  next
		  
		  MySemaphore.Release
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Sub Operator_Convert(source() As Variant)
		  Constructor
		  
		  Data.ResizeTo source.LastIndex
		  
		  for i as integer = 0 to source.LastIndex
		    Data( i ) = source( i )
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Function Operator_Subscript(index As Integer) As Variant
		  MySemaphore.Signal
		  
		  var result as variant = self.Data( index )
		  
		  MySemaphore.Release
		  
		  return result
		  
		  Exception err as RuntimeException
		    try
		      MySemaphore.Release
		    end try
		    
		    raise err
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Sub Operator_Subscript(index As Integer, Assigns item As Variant)
		  MySemaphore.Signal
		  
		  self.Data( index ) = item
		  
		  MySemaphore.Release
		  
		  Exception err as RuntimeException
		    try
		      MySemaphore.Release
		    end try
		    
		    raise err
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Pop() As Variant
		  MySemaphore.Signal
		  
		  var result as variant = self.Data.Pop
		  
		  MySemaphore.Release
		  
		  return result
		  
		  Exception err as RuntimeException
		    try
		      MySemaphore.Release
		    end try
		    
		    raise err
		    
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveAll()
		  MySemaphore.Signal
		  
		  Data.RemoveAll
		  
		  MySemaphore.Release
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveAt(index As Integer)
		  MySemaphore.Signal
		  
		  Data.RemoveAt( index )
		  
		  MySemaphore.Release
		  
		  Exception err as RuntimeException
		    try
		      MySemaphore.Release
		    end try
		    
		    raise err
		    
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResizeTo(newSize As Integer)
		  if newSize < -1 then
		    raise new OutOfBoundsException
		  end if
		  
		  MySemaphore.Signal
		  
		  Data.ResizeTo newSize
		  
		  MySemaphore.Release
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Shuffle()
		  MySemaphore.Signal
		  
		  Data.Shuffle
		  
		  MySemaphore.Release
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Sort(sorter As SortDelegate)
		  MySemaphore.Signal
		  
		  Data.Sort sorter
		  
		  MySemaphore.Release
		  
		  Exception err As RuntimeException
		    try
		      MySemaphore.Release
		    end try
		    
		    raise err
		    
		End Sub
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h21
		Private Delegate Function SortDelegate(item1 As Variant, item2 As Variant) As Integer
	#tag EndDelegateDeclaration


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  MySemaphore.Signal
			  
			  var count as integer = self.Data.Count
			  
			  MySemaphore.Release
			  
			  return count
			End Get
		#tag EndGetter
		Count As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected Data() As Variant
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  MySemaphore.Signal
			  
			  var lastIndex as integer = self.Data.LastIndex
			  
			  MySemaphore.Release
			  
			  return lastIndex
			End Get
		#tag EndGetter
		LastIndex As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected MySemaphore As Semaphore
	#tag EndProperty


	#tag Constant, Name = FirstIndex, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant


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
		#tag ViewProperty
			Name="Count"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LastIndex"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
