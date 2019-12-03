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
	node [ fontname = "Ubuntu Mono" fontstyle = "bold" fontsize = "12" shape = "polygon" color = "blue" penwidth = 3 ];
	edge [ color = "black" penwidth = 2 ]
	range [ shape = "house" ];
	range -> common_range
	range -> output_range
	range -> sized_range
	range -> disabled_size_range
	subgraph {
		rank="same"
		common_range
		view
		forward_range
	}
	subgraph {
		rank="same"
		output_range
		enable_view
		bidirectional_range
	}
	subgraph {
		rank="same"
		sized_range
		view_base
		random_access_range
	}
	subgraph {
		rank="same"
		disabled_size_range
		viewable_base
		contiguous_range
	}
	range -> view
	range -> enable_view
	range -> view_base
	view_base -> viewable_base
	range -> input_range
	input_range -> forward_range
	forward_range -> bidirectional_range
	bidirectional_range -> random_access_range
	random_access_range -> contiguous_range
}
EOF

# Create the .svg file
dot $DOT -Tsvg -o $SVG

# Delete the .dot file
rm -f $DOT 2>/dev/null
