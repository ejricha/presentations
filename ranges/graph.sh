#!/bin/bash
# graph.sh
#
# Create .svg showing the range concepts

B=concepts
DOT=$B.dot
SVG=$B.svg

# Create the .dot file
cat << EOF > $DOT
strict digraph "Concepts" {
	node [ fontname = "monospace" fontsize = "12" shape = "polygon" color = "blue" penwidth = 3 ];
	edge [ color = "black" penwidth = 2 ]
	range [ shape = "house" ];
	range -> common_range
	sized [ label = "sized_range\ndisable_sized_range" ];
	range -> sized
	range -> output_range
	view [ label = "view\nenable_view\nview_base" ];
	range -> view
	view -> viewable_range
	range -> input_range
	input_range -> forward_range
	forward_range -> bidirectional_range
	bidirectional_range -> random_access_range
	random_access_range -> contiguous_range
	subgraph {
		rank="same"
		common_range
		input_range
	}
	subgraph {
		rank="same"
		sized
		forward_range
	}
	subgraph {
		rank="same"
		output_range
		bidirectional_range
	}
	subgraph {
		rank="same"
		view
		random_access_range
	}
	subgraph {
		rank="same"
		viewable_range
		contiguous_range
	}
}
EOF

# Create the .svg file
dot $DOT -Tsvg -o $SVG

# Delete the .dot file
rm -f $DOT 2>/dev/null
