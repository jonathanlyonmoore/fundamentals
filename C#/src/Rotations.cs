using System;
namespace algorithms
{
	
	sealed class Rotations
	{
		/// <summary> Rotate binary tree node with left child.
		/// For AVL trees, this is a single rotation for case 1.
		/// </summary>
		internal static BinaryNode withLeftChild(BinaryNode k2)
		{
			BinaryNode k1 = k2.left;
			k2.left = k1.right;
			k1.right = k2;
			return k1;
		}
		
		/// <summary> Rotate binary tree node with right child.
		/// For AVL trees, this is a single rotation for case 4.
		/// </summary>
		internal static BinaryNode withRightChild(BinaryNode k1)
		{
			BinaryNode k2 = k1.right;
			k1.right = k2.left;
			k2.left = k1;
			return k2;
		}
		
		/// <summary> Double rotate binary tree node: first left child
		/// with its right child; then node k3 with new left child.
		/// For AVL trees, this is a double rotation for case 2.
		/// </summary>
		internal static BinaryNode doubleWithLeftChild(BinaryNode k3)
		{
			k3.left = withRightChild(k3.left);
			return withLeftChild(k3);
		}
		
		/// <summary> Double rotate binary tree node: first right child
		/// with its left child; then node k1 with new right child.
		/// For AVL trees, this is a double rotation for case 3.
		/// </summary>
		internal static BinaryNode doubleWithRightChild(BinaryNode k1)
		{
			k1.right = withLeftChild(k1.right);
			return withRightChild(k1);
		}
	}
}