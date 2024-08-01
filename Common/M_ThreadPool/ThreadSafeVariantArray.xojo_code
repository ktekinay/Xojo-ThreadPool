#tag Class
Class ThreadSafeVariantArray
Implements Iterable
	#tag Method, Flags = &h0
		Sub Add(item As Variant)
		  var holder as new LockHolder( Locker )
		  
		  self.Data.Add item
		  
		  holder = nil
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddAt(index As Integer, item As Variant)
		  var holder as new LockHolder( Locker )
		  
		  Data.AddAt( index, item )
		  
		  holder = nil
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(type As Thread.Types = Thread.Types.Preemptive)
		  Locker = new Semaphore
		  Locker.Type = type
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IndexOf(item As Variant) As Integer
		  var holder as new LockHolder( Locker )
		  
		  var result as integer = Data.IndexOf( item )
		  
		  holder = nil
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Function Iterator() As Iterator
		  var holder as new LockHolder( Locker )
		  
		  var newArr() as variant
		  newArr.ResizeTo Data.LastIndex
		  
		  for i as integer = 0 to Data.LastIndex
		    newArr( i ) = Data( i )
		  next
		  
		  holder = nil
		  
		  return new M_ThreadPool.ThreadSafeVariantArrayIterator( newArr )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Function Operator_Convert() As Variant()
		  var holder as new LockHolder( Locker )
		  
		  var result() as variant
		  result.ResizeTo Data.LastIndex
		  
		  for i as integer = 0 to Data.LastIndex
		    result( i ) = Data( i )
		  next
		  
		  holder = nil
		  
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
		  var holder as new LockHolder( Locker )
		  
		  var result as variant = self.Data( index )
		  
		  holder = nil
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Sub Operator_Subscript(index As Integer, Assigns item As Variant)
		  var holder as new LockHolder( Locker )
		  
		  self.Data( index ) = item
		  
		  holder = nil
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Pop() As Variant
		  var holder as new LockHolder( Locker )
		  
		  var result as variant = self.Data.Pop
		  
		  holder = nil
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveAll()
		  var holder as new LockHolder( Locker )
		  
		  Data.RemoveAll
		  
		  holder = nil
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveAt(index As Integer)
		  var holder as new LockHolder( Locker )
		  
		  Data.RemoveAt( index )
		  
		  holder = nil
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResizeTo(newSize As Integer)
		  if newSize < -1 then
		    raise new OutOfBoundsException
		  end if
		  
		  var holder as new LockHolder( Locker )
		  
		  Data.ResizeTo newSize
		  
		  holder = nil
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Shuffle()
		  var holder as new LockHolder( Locker )
		  
		  Data.Shuffle
		  
		  holder = nil
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Sort(sorter As SortDelegate)
		  var holder as new LockHolder( Locker )
		  
		  Data.Sort sorter
		  
		  holder = nil
		  
		  
		End Sub
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h21
		Private Delegate Function SortDelegate(item1 As Variant, item2 As Variant) As Integer
	#tag EndDelegateDeclaration


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  var count as integer
			  
			  var holder as new LockHolder( Locker )
			  
			  count = self.Data.Count
			  
			  holder = nil
			  
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
			  var holder as new LockHolder( Locker )
			  
			  var lastIndex as integer = self.Data.LastIndex
			  
			  holder = nil
			  
			  return lastIndex
			End Get
		#tag EndGetter
		LastIndex As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected Locker As Semaphore
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
