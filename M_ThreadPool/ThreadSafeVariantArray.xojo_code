#tag Class
Class ThreadSafeVariantArray
Implements Iterable
	#tag Method, Flags = &h0
		Sub Add(item As Variant)
		  Locker.Enter
		  
		  self.Data.Add item
		  
		  Locker.Leave
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddAt(index As Integer, item As Variant)
		  Locker.Enter
		  
		  Data.AddAt( index, item )
		  
		  Locker.Leave
		  
		  Exception err as RuntimeException
		    try
		      Locker.Leave
		    end try
		    
		    raise err
		    
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  Locker = new CriticalSection
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IndexOf(item As Variant) As Integer
		  Locker.Enter
		  
		  var result as integer = Data.IndexOf( item )
		  
		  Locker.Leave
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Function Iterator() As Iterator
		  Locker.Enter
		  
		  var newArr() as variant
		  newArr.ResizeTo Data.LastIndex
		  
		  for i as integer = 0 to Data.LastIndex
		    newArr( i ) = Data( i )
		  next
		  
		  Locker.Leave
		  
		  return new M_ThreadPool.ThreadSafeVariantArrayIterator( newArr )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Function Operator_Convert() As Variant()
		  Locker.Enter
		  
		  var result() as variant
		  result.ResizeTo Data.LastIndex
		  
		  for i as integer = 0 to Data.LastIndex
		    result( i ) = Data( i )
		  next
		  
		  Locker.Leave
		  
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
		  Locker.Enter
		  
		  var result as variant = self.Data( index )
		  
		  Locker.Leave
		  
		  return result
		  
		  Exception err as RuntimeException
		    try
		      Locker.Leave
		    end try
		    
		    raise err
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Sub Operator_Subscript(index As Integer, Assigns item As Variant)
		  Locker.Enter
		  
		  self.Data( index ) = item
		  
		  Locker.Leave
		  
		  Exception err as RuntimeException
		    try
		      Locker.Leave
		    end try
		    
		    raise err
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Pop() As Variant
		  Locker.Enter
		  
		  var result as variant = self.Data.Pop
		  
		  Locker.Leave
		  
		  return result
		  
		  Exception err as RuntimeException
		    try
		      Locker.Leave
		    end try
		    
		    raise err
		    
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveAll()
		  Locker.Enter
		  
		  Data.RemoveAll
		  
		  Locker.Leave
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveAt(index As Integer)
		  Locker.Enter
		  
		  Data.RemoveAt( index )
		  
		  Locker.Leave
		  
		  Exception err as RuntimeException
		    try
		      Locker.Leave
		    end try
		    
		    raise err
		    
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResizeTo(newSize As Integer)
		  if newSize < -1 then
		    raise new OutOfBoundsException
		  end if
		  
		  Locker.Enter
		  
		  Data.ResizeTo newSize
		  
		  Locker.Leave
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Shuffle()
		  Locker.Enter
		  
		  Data.Shuffle
		  
		  Locker.Leave
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Sort(sorter As SortDelegate)
		  Locker.Enter
		  
		  Data.Sort sorter
		  
		  Locker.Leave
		  
		  Exception err As RuntimeException
		    try
		      Locker.Leave
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
			  var count as integer
			  
			  Locker.Enter
			  
			  count = self.Data.Count
			  
			  Locker.Leave
			  
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
			  Locker.Enter
			  
			  var lastIndex as integer = self.Data.LastIndex
			  
			  Locker.Leave
			  
			  return lastIndex
			End Get
		#tag EndGetter
		LastIndex As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected Locker As CriticalSection
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
