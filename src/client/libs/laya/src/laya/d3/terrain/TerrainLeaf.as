package laya.d3.terrain {
	import laya.d3.core.render.BaseRender;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	
	/**
	 * <code>TerrainLeaf</code> Terrain的叶子节点
	 */
	public class TerrainLeaf {
		public static var CHUNK_GRID_NUM:int = 64;
		public static var LEAF_GRID_NUM:int = 16;
		
		public static var LEAF_PLANE_VERTEXT_COUNT:int = (LEAF_GRID_NUM + 1) * (LEAF_GRID_NUM + 1);
		public static var LEAF_SKIRT_VERTEXT_COUNT:int =  (LEAF_GRID_NUM + 1) * 2 * 4;
		public static var LEAF_VERTEXT_COUNT:int = LEAF_PLANE_VERTEXT_COUNT + LEAF_SKIRT_VERTEXT_COUNT;
		
		public static var LEAF_PLANE_MAX_INDEX_COUNT:int = LEAF_GRID_NUM * LEAF_GRID_NUM * 6;
		public static var LEAF_SKIRT_MAX_INDEX_COUNT:int = LEAF_GRID_NUM * 4 * 6;
		public static var LEAF_MAX_INDEX_COUNT:int = LEAF_PLANE_MAX_INDEX_COUNT + LEAF_SKIRT_MAX_INDEX_COUNT;
		
		private static var _maxLODLevel:int = __JS__( "Math.log2(TerrainLeaf.LEAF_GRID_NUM)" );
		private static var _planeLODIndex:Vector.<Vector.<Uint16Array>>;
		private static var _skirtLODIndex:Vector.<Vector.<Uint16Array>>;
		private static var _bInit:Boolean = false;
		
		public var _boundingSphere:BoundSphere;
		public var _boundingBox:BoundBox;
		public var _sizeOfY:Vector2;
		public var _currentLODLevel:int;
		private var _originalBoundingSphere:BoundSphere;
		private var _originalBoundingBox:BoundBox;
		private var _originalBoundingBoxCorners:Vector.<Vector3>;
		private var _bUseStrip:Boolean = false;
		private var _gridSize:Number;
		private var _beginGridX:int;//针对整个大地形的偏移
		private var _beginGridZ:int;//针对整个大地形的偏移
		private var _LODError:Float32Array;
		
		public static function __init__():void
		{
			if (!_bInit)
			{
				var nLeafNum:int = (CHUNK_GRID_NUM / LEAF_GRID_NUM) * (CHUNK_GRID_NUM / LEAF_GRID_NUM);
				//plane的LODIndex
				_planeLODIndex = new Vector.<Vector.<Uint16Array>>( nLeafNum );
				var i:int = 0, j:int = 0,k:int=0, n:int = 0, n1:int = 0, nOffset:int = 0;
				var nOriginIndexArray:Uint16Array = null,nTempIndex:Uint16Array=null;
				for ( i = 0; i < nLeafNum; i++ )
				{
					_planeLODIndex[i] = new Vector.<Uint16Array>( _maxLODLevel + 1 );
				}
				for ( i = 0,n = _maxLODLevel + 1; i < n; i++ )
				{
					_planeLODIndex[0][i] = calcPlaneLODIndex(i);
				}
				for ( i = 1; i < nLeafNum; i++ )
				{
					nOffset = i * LEAF_PLANE_VERTEXT_COUNT;
					for ( j = 0, n1 = _maxLODLevel + 1; j < n1; j++  )
					{
						nOriginIndexArray = _planeLODIndex[0][j];
						nTempIndex = new Uint16Array( nOriginIndexArray.length );
						for ( k = 0; k < nOriginIndexArray.length; k++ )
						{
							nTempIndex[k] = nOriginIndexArray[k] + nOffset;
						}
						_planeLODIndex[i][j]  = nTempIndex;
					}
				}
				//skirt的LODIndex
				_skirtLODIndex = new Vector.<Vector.<Uint16Array>>( nLeafNum );
				for ( i = 0; i < nLeafNum; i++ )
				{
					_skirtLODIndex[i] = new Vector.<Uint16Array>( _maxLODLevel + 1 );
				}
				for ( i = 0,n = _maxLODLevel + 1; i < n; i++ )
				{
					_skirtLODIndex[0][i] = calcSkirtLODIndex(i);
				}
				for ( i = 1; i < nLeafNum; i++ )
				{
					nOffset = i * LEAF_SKIRT_VERTEXT_COUNT;
					for ( j = 0, n1 = _maxLODLevel + 1; j < n1; j++  )
					{
						nOriginIndexArray = _skirtLODIndex[0][j];
						nTempIndex = new Uint16Array( nOriginIndexArray.length );
						for ( k = 0; k < nOriginIndexArray.length; k++ )
						{
							nTempIndex[k] = nOriginIndexArray[k] + nOffset;
						}
						_skirtLODIndex[i][j]  = nTempIndex;
					}
				}
				_bInit = true;
			}
		}
		public static function getPlaneLODIndex(leafIndex:int, LODLevel:int):Uint16Array
		{
			return _planeLODIndex[leafIndex][LODLevel];
		}
		public static function getSkirtLODIndex(leafIndex:int, LODLevel:int):Uint16Array
		{
			return _skirtLODIndex[leafIndex][LODLevel];
		}
		private static function calcPlaneLODIndex(level:int):Uint16Array
		{
			if ( level > _maxLODLevel ) level = _maxLODLevel;
			var nGridNumAddOne:int = LEAF_GRID_NUM + 1;
			var nNum:int = 0;
			var indexBuffer:Uint16Array = null;
			var nLODGridNum:int = TerrainLeaf.LEAF_GRID_NUM / Math.pow(2, level );
			indexBuffer = new Uint16Array( nLODGridNum * nLODGridNum * 6);
			var nGridSpace:int = TerrainLeaf.LEAF_GRID_NUM / nLODGridNum;
			for ( var i:int = 0; i < LEAF_GRID_NUM; i += nGridSpace )
			{
				for ( var j:int = 0; j < LEAF_GRID_NUM; j += nGridSpace )
				{
					indexBuffer[nNum] = (i + nGridSpace) * nGridNumAddOne + j; nNum++;
					indexBuffer[nNum] = i * nGridNumAddOne + j; nNum++;
					indexBuffer[nNum] = i * nGridNumAddOne + j + nGridSpace; nNum++;
					indexBuffer[nNum] = i * nGridNumAddOne + j + nGridSpace;nNum++;
					indexBuffer[nNum] = (i + nGridSpace) * nGridNumAddOne + j + nGridSpace; nNum++;
					indexBuffer[nNum] = (i + nGridSpace) * nGridNumAddOne + j; nNum++;
				}
			}
			return indexBuffer;
		}
		private static function calcSkirtLODIndex(level:int):Uint16Array
		{
			if ( level > _maxLODLevel ) level = _maxLODLevel;
			//裙边顶点总的偏移
			var nSkirtIndexOffset:int =  (CHUNK_GRID_NUM / LEAF_GRID_NUM) * (CHUNK_GRID_NUM / LEAF_GRID_NUM) * LEAF_PLANE_VERTEXT_COUNT;
			var nGridNumAddOne:int = LEAF_GRID_NUM + 1;
			var nNum:int = 0;
			var indexBuffer:Uint16Array = null;
			var nLODGridNum:int = TerrainLeaf.LEAF_GRID_NUM / Math.pow(2, level );
			indexBuffer = new Uint16Array( nLODGridNum * 4 * 6 );
			var nGridSpace:int = TerrainLeaf.LEAF_GRID_NUM / nLODGridNum;
			for ( var j:int = 0 ; j < 4; j++ )
			{
				for ( var i:int = 0; i < LEAF_GRID_NUM; i += nGridSpace )
				{
					indexBuffer[nNum] = nSkirtIndexOffset + nGridNumAddOne + i; nNum++;
					indexBuffer[nNum] = nSkirtIndexOffset + i; nNum++;
					indexBuffer[nNum] = nSkirtIndexOffset + i + nGridSpace; nNum++;
					
					indexBuffer[nNum] = nSkirtIndexOffset + i + nGridSpace;nNum++;
					indexBuffer[nNum] = nSkirtIndexOffset + nGridNumAddOne + i + nGridSpace; nNum++;
					indexBuffer[nNum] = nSkirtIndexOffset + nGridNumAddOne + i; nNum++;
				}
				nSkirtIndexOffset += nGridNumAddOne * 2;
			}
			return indexBuffer;
		}
		public static function getHeightFromTerrainHeightData( x:int, z:int, terrainHeightData:Float32Array, heighDataWidth:int, heightDataHeight:int ):Number
		{
			x = x < 0 ? 0 : x;
			x = (x >= heighDataWidth) ? heighDataWidth - 1 : x;
			z = z < 0 ? 0 :z;
			z = (z >= heightDataHeight) ? heightDataHeight - 1 : z;
			return terrainHeightData[ z * heighDataWidth + x ];
		}
		/**
		 * 创建一个新的 <code>TerrainLeaf</code> 实例。
		 * @param owner 地形的叶子。
		 */
		public function TerrainLeaf() {
			__init__();
			_currentLODLevel = 0;
		}
		public function calcVertextNorml( x:int, z:int, terrainHeightData:Float32Array, heighDataWidth:int, heightDataHeight:int,normal:Vector3):void
		{
			var dZ:Number = 0, dX:Number = 0;
			dX  = getHeightFromTerrainHeightData (x-1, z-1, terrainHeightData,heighDataWidth,heightDataHeight) * -1.0;
			dX += getHeightFromTerrainHeightData (x-1, z  , terrainHeightData,heighDataWidth,heightDataHeight) * -1.0;
			dX += getHeightFromTerrainHeightData (x-1, z+1, terrainHeightData,heighDataWidth,heightDataHeight) * -1.0;
			dX += getHeightFromTerrainHeightData (x+1, z-1, terrainHeightData,heighDataWidth,heightDataHeight) *  1.0;
			dX += getHeightFromTerrainHeightData (x+1, z  , terrainHeightData,heighDataWidth,heightDataHeight) *  1.0;
			dX += getHeightFromTerrainHeightData (x+1, z+1, terrainHeightData,heighDataWidth,heightDataHeight) *  1.0;
			
			dZ  = getHeightFromTerrainHeightData (x-1, z-1, terrainHeightData,heighDataWidth,heightDataHeight) * -1.0;
			dZ += getHeightFromTerrainHeightData (x  , z-1, terrainHeightData,heighDataWidth,heightDataHeight) * -1.0;
			dZ += getHeightFromTerrainHeightData (x+1, z-1, terrainHeightData,heighDataWidth,heightDataHeight) * -1.0;
			dZ += getHeightFromTerrainHeightData (x-1, z+1, terrainHeightData,heighDataWidth,heightDataHeight) *  1.0;
			dZ += getHeightFromTerrainHeightData (x  , z+1, terrainHeightData,heighDataWidth,heightDataHeight) *  1.0;
			dZ += getHeightFromTerrainHeightData (x+1, z+1, terrainHeightData,heighDataWidth,heightDataHeight) *  1.0;
			
			normal.x = -dX;
			normal.y = 6;
			normal.z = -dZ;
			Vector3.normalize(normal, normal);
		}
		public function calcVertextNormlUV( x:int, z:int,terrainWidth:Number,terrainHeight:Number,normal:Vector3):void
		{
			normal.x = x/terrainWidth;
			normal.y = z/terrainHeight;
			normal.z = z/terrainHeight;
		}
		public function calcVertextBuffer(offsetChunkX:int, offsetChunkZ:int, beginX:int, beginZ:int, girdSize:Number, vertextBuffer:Float32Array, 
								offset:int, strideSize:int,terrainHeightData:Float32Array,heighDataWidth:int,heightDataHeight:int ):void
		{
			_gridSize = girdSize;
			_beginGridX = offsetChunkX * CHUNK_GRID_NUM + beginX;
			_beginGridZ = offsetChunkZ * CHUNK_GRID_NUM + beginZ;
			var nNum:int = offset * strideSize;
			var x:Number, y:Number, z:Number;
			var minY:Number = 2147483647;
			var maxY:Number = -2147483648;
			var normal:Vector3 = new Vector3();
			for( var i:int = 0,s:int = LEAF_GRID_NUM + 1 ; i < s; i++ )
			{
				for( var j:int = 0,s1:int = LEAF_GRID_NUM + 1 ; j < s1; j++ )
				{
					x = (_beginGridX + j) * _gridSize;
					z = (_beginGridZ + i) * _gridSize;
					y = terrainHeightData[ (_beginGridZ + i) * (heighDataWidth) + (_beginGridX + j) ];
					minY = y < minY ? y : minY;
					maxY = y > maxY ? y : maxY;
					vertextBuffer[nNum] = x; nNum++; vertextBuffer[nNum] = y; nNum++; vertextBuffer[nNum] = z; nNum++;
					//计算norma的UV
					calcVertextNormlUV( _beginGridX + j, _beginGridZ + i, heighDataWidth, heightDataHeight, normal);
					//给顶点赋值
					vertextBuffer[nNum] = normal.x; nNum++; vertextBuffer[nNum] = normal.y; nNum++; vertextBuffer[nNum] = normal.z; nNum++;
					vertextBuffer[nNum] = (beginX + j) / CHUNK_GRID_NUM; nNum++; vertextBuffer[nNum] =  (beginZ + i) / CHUNK_GRID_NUM; nNum++; 
					vertextBuffer[nNum] = _beginGridX + j; nNum++; vertextBuffer[nNum] = _beginGridZ + i; nNum++;
				}
			}
			_sizeOfY = new Vector2( minY-1, maxY+1 );
			calcLODErrors(terrainHeightData,heighDataWidth,heightDataHeight);
			calcOriginalBoudingBoxAndSphere();
		}
		public function calcSkirtVertextBuffer(offsetChunkX:int, offsetChunkZ:int, beginX:int, beginZ:int, girdSize:int, vertextBuffer:Float32Array, 
								offset:int, strideSize:int,terrainHeightData:Float32Array,heighDataWidth:int,heightDataHeight:int ):void
		{
			_gridSize = girdSize;
			_beginGridX = offsetChunkX * CHUNK_GRID_NUM + beginX;
			_beginGridZ = offsetChunkZ * CHUNK_GRID_NUM + beginZ;
			var nNum:int = offset * strideSize;
			var i:int = 0, j:int = 0,s:int = LEAF_GRID_NUM + 1;
			var x:Number, y:Number, z:Number;
			var normal:Vector3 = new Vector3();
			var hZIndex:int = 0;
			var hXIndex:int = 0;
			var h:Number = 0;
			var zh:Number = 0;
			var xh:Number = 0;
			//上
			for ( i = 0; i < 2; i++ )
			{
				for ( j = 0; j < s; j++ )
				{
					x = (_beginGridX + j) * _gridSize;
					y = (i==1 ? terrainHeightData[ _beginGridZ * heighDataWidth + (_beginGridX + j)] : -_gridSize);
					z = (_beginGridZ + 0) * _gridSize;
					vertextBuffer[nNum] = x; nNum++; vertextBuffer[nNum] = y; nNum++; vertextBuffer[nNum] = z; nNum++;
					//计算法线
					if ( i == 0 )
					{
						hZIndex = (_beginGridZ - 1);
					}
					else
					{
						hZIndex = _beginGridZ;
					}
					calcVertextNormlUV( _beginGridX + j,hZIndex,heighDataWidth, heightDataHeight, normal);
					
					//给顶点赋值
					vertextBuffer[nNum] = normal.x; nNum++; vertextBuffer[nNum] = normal.y; nNum++; vertextBuffer[nNum] = normal.z; nNum++;
					vertextBuffer[nNum] = (beginX + j) / CHUNK_GRID_NUM; nNum++; vertextBuffer[nNum] =  (beginZ + 0) / CHUNK_GRID_NUM; nNum++; 
					vertextBuffer[nNum] = _beginGridX + j; nNum++; vertextBuffer[nNum] = _beginGridZ + (i == 0) ? -1 : 0; nNum++;
				}
			}
			//下
			for ( i = 0; i < 2; i++ )
			{
				for ( j = 0; j < s; j++ )
				{
					x = (_beginGridX + j) * _gridSize;
					y = (i==0 ? terrainHeightData[ (_beginGridZ + LEAF_GRID_NUM) * (heighDataWidth) + (_beginGridX + j)] : -_gridSize);
					z = (_beginGridZ + LEAF_GRID_NUM) * _gridSize;
					vertextBuffer[nNum] = x; nNum++; vertextBuffer[nNum] = y; nNum++; vertextBuffer[nNum] = z; nNum++;
					
					//计算法线
					if ( i == 0 )
					{
						hZIndex = _beginGridZ + LEAF_GRID_NUM;
					}
					else
					{
						hZIndex = (_beginGridZ + LEAF_GRID_NUM + 1);
					}
					calcVertextNormlUV( _beginGridX + j, hZIndex,heighDataWidth, heightDataHeight, normal);
					
					//给顶点赋值
					vertextBuffer[nNum] = normal.x; nNum++; vertextBuffer[nNum] = normal.y; nNum++; vertextBuffer[nNum] = normal.z; nNum++;
					vertextBuffer[nNum] = (beginX + j) / CHUNK_GRID_NUM; nNum++; vertextBuffer[nNum] =  (beginZ + LEAF_GRID_NUM) / CHUNK_GRID_NUM; nNum++; 
					vertextBuffer[nNum] = _beginGridX + j; nNum++; vertextBuffer[nNum] = _beginGridZ + LEAF_GRID_NUM + i; nNum++;
				}
			}
			//左
			for ( i = 0; i < 2; i++ )
			{
				for ( j = 0; j < s; j++ )
				{
					x = (_beginGridX + 0) * _gridSize;
					y = (i==0 ? terrainHeightData[ (_beginGridZ + j) * (heighDataWidth) + (_beginGridX + 0)]  : -_gridSize);
					z = (_beginGridZ + j) * _gridSize;
					vertextBuffer[nNum] = x; nNum++; vertextBuffer[nNum] = y; nNum++; vertextBuffer[nNum] = z; nNum++;
					
					//计算法线
					if ( i == 0 )
					{
						hXIndex = _beginGridX;
					}
					else
					{
						hXIndex = (_beginGridX - 1);
					}
					calcVertextNormlUV( hXIndex, _beginGridZ + j, heighDataWidth, heightDataHeight, normal);
					
					//给顶点赋值
					vertextBuffer[nNum] = normal.x; nNum++; vertextBuffer[nNum] = normal.y; nNum++; vertextBuffer[nNum] = normal.z; nNum++;
					vertextBuffer[nNum] = (beginX + 0) / CHUNK_GRID_NUM; nNum++; vertextBuffer[nNum] =  (beginZ + j) / CHUNK_GRID_NUM; nNum++; 
					vertextBuffer[nNum] = _beginGridX + (i == 0) ? 0 : -1; nNum++; vertextBuffer[nNum] = _beginGridZ + j; nNum++;
				}
			}
			//右
			for ( i = 0; i < 2; i++ )
			{
				for ( j = 0; j < s; j++ )
				{
					x = (_beginGridX + LEAF_GRID_NUM) * _gridSize;
					y = (i==1 ? terrainHeightData[ (_beginGridZ + j) * (heighDataWidth) + (_beginGridX + LEAF_GRID_NUM)] : -_gridSize);
					z = (_beginGridZ + j) * _gridSize;
					vertextBuffer[nNum] = x; nNum++; vertextBuffer[nNum] = y; nNum++; vertextBuffer[nNum] = z; nNum++;
					//计算法线
					if ( i == 0 )
					{
						hXIndex = _beginGridX + LEAF_GRID_NUM + 1;
					}
					else
					{
						hXIndex = _beginGridX + LEAF_GRID_NUM;
					}
					calcVertextNormlUV( hXIndex, _beginGridZ + j,heighDataWidth, heightDataHeight, normal);
					
					//给顶点赋值
					vertextBuffer[nNum] = normal.x; nNum++; vertextBuffer[nNum] = normal.y; nNum++; vertextBuffer[nNum] = normal.z; nNum++;
					vertextBuffer[nNum] = (beginX + LEAF_GRID_NUM) / CHUNK_GRID_NUM; nNum++; vertextBuffer[nNum] =  (beginZ + j) / CHUNK_GRID_NUM; nNum++; 
					vertextBuffer[nNum] =  _beginGridX + LEAF_GRID_NUM + (i == 1 ? 0 : 1 ); nNum++; vertextBuffer[nNum] = _beginGridZ + j; nNum++;
				}
			}
		}
		public function calcOriginalBoudingBoxAndSphere():void
		{
			var min:Vector3 = new Vector3( _beginGridX * _gridSize, _sizeOfY.x, _beginGridZ * _gridSize );
			var max:Vector3 = new Vector3( ( _beginGridX + LEAF_GRID_NUM ) * _gridSize, _sizeOfY.y, ( _beginGridZ + LEAF_GRID_NUM ) * _gridSize );
			_originalBoundingBox = new BoundBox(min, max);
			var size:Vector3 = new Vector3();
			Vector3.subtract( max, min, size );
			Vector3.scale(size, 0.5, size);
			var center:Vector3 = new Vector3();
			Vector3.add( min, size, center );
			_originalBoundingSphere = new BoundSphere(center, Vector3.scalarLength(size));
			_originalBoundingBoxCorners = new Vector.<Vector3>(8);
			_originalBoundingBox.getCorners(_originalBoundingBoxCorners);
			_boundingBox = new BoundBox( new Vector3( -0.5, -0.5, -0.5), new Vector3(0.5,0.5,0.5) );
			_boundingSphere = new BoundSphere( new Vector3(0, 0, 0), 1 );
		}
		public function calcLeafBoudingBox(worldMatrix:Matrix4x4):void
		{
			for (var i:int = 0; i < 8; i++)
			{
				Vector3.transformCoordinate(_originalBoundingBoxCorners[i], worldMatrix, BaseRender._tempBoudingBoxCorners[i]);
			}
			BoundBox.createfromPoints(BaseRender._tempBoudingBoxCorners, _boundingBox);
		}
		public function calcLeafBoudingSphere(worldMatrix:Matrix4x4,maxScale:Number):void
		{
			Vector3.transformCoordinate( _originalBoundingSphere.center, worldMatrix, _boundingSphere.center);
			_boundingSphere.radius = _originalBoundingSphere.radius * maxScale;
		}
		public function calcLODErrors(terrainHeightData:Float32Array,heighDataWidth:int,heightDataHeight:int):void
		{
			_LODError = new Float32Array( _maxLODLevel + 1 );
			var step:int = 1;
			for (var i:int = 0, n:int = _maxLODLevel + 1; i < n; i++) 
			{
				var maxError:Number = 0;
				for (var y:int = 0, n1:int = LEAF_GRID_NUM; y < n1; y += step) 
				{
					for (var x:int = 0, n2:int = LEAF_GRID_NUM; x < n2; x += step) 
					{
						var z00:Number = terrainHeightData[ (_beginGridZ + y) * heighDataWidth + (_beginGridX + x) ];
						var z10:Number = terrainHeightData[ (_beginGridZ + y) * heighDataWidth + (_beginGridX + x) + step ];
						var z01:Number = terrainHeightData[ (_beginGridZ + y + step) * heighDataWidth + (_beginGridX + x) ];
						var z11:Number = terrainHeightData[ (_beginGridZ + y + step) * heighDataWidth + (_beginGridX + x) + step ];
						
						for (var j:int = 0; j < step; j++) 
						{
							var ys:Number = j / step;
							for (var k:int = 0; k < step; k++) 
							{
								var xs:Number = k / step;
								var z:Number = terrainHeightData[ (_beginGridZ + y + j) * heighDataWidth + (_beginGridX + x) + k ];
								var iz:Number = (xs + ys <= 1) ? 
									  (z00 + (z10 - z00) * xs + (z01 - z00) * ys) : (z11 + (z01 - z11) * (1 - xs) + (z10 - z11) * (1 - ys));
								var error:Number = Math.abs(iz - z); 
								maxError = Math.max(maxError, error);
							}								
						}
					}
				}
				step *= 2;
				_LODError[i] = maxError;
			}
		}
		public function determineLod(eyePos:Vector3, perspectiveFactor:Number, tolerance:Number):int
		{
			return 0;
			var nDistanceToEye:Number = Vector3.distance(eyePos, _boundingSphere.center );
			for (var i:int = _maxLODLevel; i >= 1; i--) 
			{
				if ( _LODError[i] / nDistanceToEye * perspectiveFactor < tolerance)
				{
					_currentLODLevel = i;
					break;
				}
			}
			return _currentLODLevel;
		}
	}
}